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
}
