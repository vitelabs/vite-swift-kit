//
//  Box.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2018/12/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import PromiseKit
import BigInt

struct Box {

    static func setUp() {
        Provider.default.update(server: RPCServer(url: URL(string: "http://148.70.30.139:48132/123")!))
        LogConfig.instance.isEnable = true
    }

    static let viteToken = ViteWalletConst.viteToken
    static let encryptedKey = "12345678"

    static var genesisWallet: Wallet = {
        let name = "genesis"
        let mnemonic = "alarm canal scheme actor left length bracket slush tuna garage prepare scout school pizza invest rose fork scorpion make enact false kidney mixed vast"
        let wallet = Wallet(uuid: name, name: name, mnemonic: mnemonic, language: .english, encryptedKey: encryptedKey)
        return wallet
    }()

    static var testWallet: Wallet = {
        let name = "test"
        let mnemonic = "nuclear buzz drift segment state heavy leaf pistol frozen casual wall kit pitch feel prevent donor idea track oil inside have lens purity wisdom"
        let wallet = Wallet(uuid: name, name: name, mnemonic: mnemonic, language: .english, encryptedKey: encryptedKey)
        return wallet
    }()


}

extension Wallet {

    func account(at index: Int) -> Account {
        return try! self.account(at: index, encryptedKey: Box.encryptedKey)
    }

    var firstAccount: Account {
        return account(at: 0)
    }

    var secondAccount: Account {
        return account(at: 1)
    }
}

extension Box {

    enum BoxError: Error {
        case dataError
    }
    struct f {
        static func afterLatestAccountBlockConfirmed(address: Address) -> Promise<AccountBlock> {
            func getPromise() -> Promise<AccountBlock> {
                return ViteNode.ledger.getLatestAccountBlock(address: address)
                    .then { ret -> Promise<AccountBlock> in
                        if let accountBlock = ret {
                            if let confirmedTimes = accountBlock.confirmedTimes, confirmedTimes > 0 {
                                printLog("confirmed!!!")
                                return Promise.value(accountBlock)
                            } else {
                                printLog("wait for confirmed")
                                return after(seconds: 1).then {
                                    return getPromise()
                                }
                            }
                        } else {
                            return Promise(error: BoxError.dataError)
                        }
                }
            }

            return getPromise()
        }

        static func receiveAll(account: Wallet.Account, _ block: @escaping () -> ()) {
            receiveAll(account: account)
                .done({ _ in
                    block()
                }).catch({ (error) in
                    printLog(error)
                    XCTAssert(false)
                })
        }

        static func receiveAll(account: Wallet.Account) -> Promise<Void> {
            func getPromise() -> Promise<Void> {
                return ViteNode.utils.receive.latestRawTxIfHasWithPow(account: account)
                    .then({ (ret) -> Promise<Void> in
                        if let ret = ret {
                            printLog("receive: \(ret.send.amount!.value.description)")
                            return afterLatestAccountBlockConfirmed(address: account.address)
                                .then({ (_) -> Promise<Void> in
                                    return getPromise()
                                })
                        } else {
                            printLog("no need to receive")
                            return Promise.value(Void())
                        }
                    })
            }

            return getPromise()
        }

        static func sendViteToSelf(account: Wallet.Account, amount: Balance, note: String? = nil) -> Promise<AccountBlock> {
            return ViteNode.transaction.getPow(account: account, toAddress: account.address, tokenId: ViteWalletConst.viteToken.id, amount: amount, note: note)
                .then { context -> Promise<AccountBlock> in
                    return ViteNode.rawTx.send.context(context)
                }.then { _ in
                    return afterLatestAccountBlockConfirmed(address: account.address)
            }
        }

        static func getTestToken(account: Wallet.Account, amount: Balance) -> Promise<Void> {
            let address = account.address
            return ViteNode.transaction.getPow(account: Box.genesisWallet.secondAccount, toAddress: address, tokenId: ViteWalletConst.viteToken.id, amount: amount, note: nil)
                .then({ context -> Promise<AccountBlock> in
                    return ViteNode.rawTx.send.context(context)
                }).then({ _ -> Promise<Void> in
                    return receiveAll(account: account)
                })
        }
    }
}


extension XCTestCase {
    func async(_ block: ( @escaping () -> () ) -> ()) {

        let expect = expectation(description: "method")
        block {
            expect.fulfill()
        }
        waitForExpectations(timeout: 6000000, handler: nil)
//        printLog("🍺🍺🍺🍺🍺🍺")
    }
}
