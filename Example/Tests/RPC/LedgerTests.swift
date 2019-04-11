//
//  LedgerTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class LedgerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
//        async { (c) in
//            Box.f.receiveAll(account: Box.testWallet.firstAccount, {
//                Box.f.receiveAll(account: Box.testWallet.secondAccount, c)
//            })
//        }
    }

    override func tearDown() {
//        async { (c) in
//            Box.f.receiveAll(account: Box.testWallet.firstAccount, {
//                Box.f.receiveAll(account: Box.testWallet.secondAccount, c)
//            })
//        }
        super.tearDown()
    }

    func testGetBalanceInfosWithoutOnroad() {
        
        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let tokenId = ViteWalletConst.viteToken.id
            let amount = Balance(value: BigInt("1000000000000000000")!)

            firstly(execute: { () -> Promise<Void> in
                return Box.f.getTestToken(account: account, amount: amount)
            }).then({ (_) -> Promise<[BalanceInfo]> in
                return ViteNode.ledger.getBalanceInfosWithoutOnroad(address: address)
            }).done({ (balanceInfos) in
                var success = false
                for balanceInfo in balanceInfos where balanceInfo.token.id == tokenId {
                    if balanceInfo.balance.value >= amount.value {
                        success = true
                    }
                }
                XCTAssert(success)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testGetLatestAccountBlock() {

        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let tokenId = ViteWalletConst.viteToken.id
            let amount = Balance(value: BigInt("1000000000000000000")!)

            firstly(execute: { () -> Promise<Void> in
                return Box.f.getTestToken(account: account, amount: amount)
            }).then({ (_) -> Promise<AccountBlock?> in
                return ViteNode.ledger.getLatestAccountBlock(address: address)
            }).done({ (accountBlock) in
                XCTAssert(accountBlock?.tokenId == tokenId)
                XCTAssert(accountBlock?.amount?.value == amount.value)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testGetAccountBlockByHash() {

        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let amount = Balance(value: BigInt("1000000000000000000")!)

            firstly(execute: { () -> Promise<Void> in
                return Box.f.getTestToken(account: account, amount: amount)
            }).then({ (_) -> Promise<AccountBlock?> in
                return ViteNode.ledger.getLatestAccountBlock(address: address)
            }).then({ (accountBlock) -> Promise<(AccountBlock, AccountBlock)> in
                return ViteNode.ledger.getAccountBlock(hash: accountBlock!.hash!).map({ b in (accountBlock!, b!) })
            }).done({ (a1, a2) in
                XCTAssert(a1.hash! == a2.hash!)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testGetAccountBlocks() {

        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let amount1 = Balance(value: BigInt("1000000000000000000")!)
            let amount2 = Balance(value: BigInt("2000000000000000000")!)

            var latestAccountBlock: AccountBlock!

            firstly(execute: { () -> Promise<Void> in
                return Box.f.receiveAll(account: account)
            }).then({ (_) -> Promise<Void> in
                return Box.f.sendViteToSelf(account: account, amount: amount1)
                    .then({ (accountBlock) -> Promise<Void> in
                        return ViteNode.utils.receive.latestRawTxIfHasWithPow(account: account).map({ _ in Void() })
                    }).then({ () -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address).map({ _ in Void() })
                    })
            }).then({ (_) -> Promise<Void> in
                return Box.f.sendViteToSelf(account: account, amount: amount2)
                    .then({ (accountBlock) -> Promise<Void> in
                        return ViteNode.utils.receive.latestRawTxIfHasWithPow(account: account).map({ _ in Void() })
                    }).then({ () -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address).map({ _ in Void() })
                    })
            }).then({ (a) -> Promise<Void> in
                return Box.f.getTestToken(account: account, amount: Balance())
            }).then({ (_) -> Promise<AccountBlock?> in
                return ViteNode.ledger.getLatestAccountBlock(address: address)
            }).then({ (a) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> in
                latestAccountBlock = a
                return ViteNode.ledger.getAccountBlocks(address: address, hash: latestAccountBlock.hash, count: 5)
            }).done({ (accountBlocks, nextHash) in
                XCTAssert(accountBlocks.count == 5)
                let a1 = accountBlocks[1]
                let a2 = accountBlocks[2]
                let a3 = accountBlocks[3]
                let a4 = accountBlocks[4]
                XCTAssert(a1.type == .receive)
                XCTAssert(a2.type == .send)
                XCTAssert(a3.type == .receive)
                XCTAssert(a4.type == .send)
                XCTAssert(a1.amount?.value == amount2.value)
                XCTAssert(a2.amount?.value == amount2.value)
                XCTAssert(a3.amount?.value == amount1.value)
                XCTAssert(a4.amount?.value == amount1.value)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testGetAccountBlocksInToken() {

        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let amount1 = Balance(value: BigInt("1000000000000000000")!)
            let amount2 = Balance(value: BigInt("2000000000000000000")!)

            var latestAccountBlock: AccountBlock!

            firstly(execute: { () -> Promise<Void> in
                return Box.f.receiveAll(account: account)
            }).then({ (_) -> Promise<Void> in
                return Box.f.sendViteToSelf(account: account, amount: amount1)
                    .then({ (accountBlock) -> Promise<Void> in
                        return ViteNode.utils.receive.latestRawTxIfHasWithPow(account: account).map({ _ in Void() })
                    }).then({ () -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address).map({ _ in Void() })
                    })
            }).then({ (_) -> Promise<Void> in
                return Box.f.sendViteToSelf(account: account, amount: amount2)
                    .then({ (accountBlock) -> Promise<Void> in
                        return ViteNode.utils.receive.latestRawTxIfHasWithPow(account: account).map({ _ in Void() })
                    }).then({ () -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address).map({ _ in Void() })
                    })
            }).then({ (a) -> Promise<Void> in
                return Box.f.getTestToken(account: account, amount: Balance())
            }).then({ (_) -> Promise<AccountBlock?> in
                return ViteNode.ledger.getLatestAccountBlock(address: address)
            }).then({ (a) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> in
                latestAccountBlock = a
                return ViteNode.ledger.getAccountBlocks(address: address, tokenId: ViteWalletConst.viteToken.id, hash: latestAccountBlock.hash, count: 5)
            }).done({ (accountBlocks, nextHash) in
                XCTAssert(accountBlocks.count == 5)
                let a1 = accountBlocks[1]
                let a2 = accountBlocks[2]
                let a3 = accountBlocks[3]
                let a4 = accountBlocks[4]
                XCTAssert(a1.type == .receive)
                XCTAssert(a2.type == .send)
                XCTAssert(a3.type == .receive)
                XCTAssert(a4.type == .send)
                XCTAssert(a1.amount?.value == amount2.value)
                XCTAssert(a2.amount?.value == amount2.value)
                XCTAssert(a3.amount?.value == amount1.value)
                XCTAssert(a4.amount?.value == amount1.value)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testGetSnapshotChainHeight() {

        async { (c) in

            firstly(execute: { () -> Promise<UInt64> in
                return ViteNode.ledger.getSnapshotChainHeight()
            }).done({ (height) in
                XCTAssert(height > 0)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }
}
