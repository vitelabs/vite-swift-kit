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
        Provider.default.update(server: RPCServer(url: URL(string: "http://148.70.30.139:48132")!))
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
                return Provider.default.getLatestAccountBlockRequest(address: address)
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

        static func receiveAll(_ block: @escaping () -> ()) {

            Provider.default.receiveLatestTransactionIfHasWithPow(account: Box.testWallet.firstAccount)
                .then { (ret) -> Promise<AccountBlock?> in
                    if let ret = ret {
                        printLog("receive: \(ret.0.amount!.value.description)")
                        return afterLatestAccountBlockConfirmed(address: Box.testWallet.firstAccount.address).map { ret -> AccountBlock? in  ret }
                    } else {
                        printLog("no need to receive")
                        return Promise.value(nil)
                    }
                }.done { (ret) in
                    if let _ = ret {
                        self.receiveAll(block)
                    } else {
                        block()
                    }
                }.catch { (error) in
                    printLog(error)
                    XCTAssert(false)
            }
        }

        static func sendViteToSelf(account: Wallet.Account, amount: Balance, note: String? = nil) -> Promise<AccountBlock> {
            return Provider.default.getPowForSendTransaction(account: account, toAddress: account.address, tokenId: ViteWalletConst.viteToken.id, amount: amount, note: note)
                .then { context -> Promise<AccountBlock> in
                    return Provider.default.sendRawTxWithContext(context)
                }.then { _ in
                    return afterLatestAccountBlockConfirmed(address: account.address)
            }
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
