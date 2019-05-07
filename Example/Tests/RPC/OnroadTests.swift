//
//  OnroadTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class OnroadTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
        async { (c) in
            firstly(execute: { () -> Promise<Void> in
                return Box.f.makeSureHasEnoughViteAmount(account: Box.testWallet.firstAccount).asVoid()
            }).done({ () in
                c()
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            })
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAll() {
        
        async { (c) in
            let account = Box.testWallet.firstAccount
            let address = account.address
            let firstAmount = Amount("1000000000000000000")!
            let secondAmount = Amount("2000000000000000000")!
            printLog("start")

            firstly { () -> Promise<AccountBlock> in
                    return Box.f.sendViteToSelf(account: Box.testWallet.firstAccount, amount: firstAmount)
                }
                .then { ret -> Promise<Void> in
                    printLog("send self \(ret.amount!.description)")
                    return Promise.value(())
                }.then { () -> Promise<AccountBlock> in
                    return Box.f.sendViteToSelf(account: Box.testWallet.firstAccount, amount: secondAmount)
                }.then { ret -> Promise<Void> in
                    printLog("send self \(ret.amount!.description)")
                    return Promise.value(Void())
                }.then { () -> Promise<[AccountBlock]> in
                    return ViteNode.onroad.getOnroadBlocks(address: address, index: 0, count: 10)
                }.then { ret -> Promise<[OnroadInfo]> in
                    XCTAssert(ret.count == 2)
                    let first = ret[0]
                    let second = ret[1]
                    // The order of the onroad collection is not guaranteed
                    if first.amount! > second.amount! {
                        XCTAssert(first.amount == secondAmount)
                        XCTAssert(second.amount == firstAmount)
                    } else {
                        XCTAssert(first.amount == firstAmount)
                        XCTAssert(second.amount == secondAmount)
                    }
                    return ViteNode.onroad.getOnroadInfos(address: address)
                }.done { ret in
                    XCTAssert(ret.count == 1)
                    let info = ret[0]
                    XCTAssert(info.unconfirmedCount == 2)
                    XCTAssert(info.unconfirmedBalance == (firstAmount + secondAmount))
                }.catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    printLog("end")
                    c()
            }
        }
    }
}
