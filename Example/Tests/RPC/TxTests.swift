//
//  TxTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class TxTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
        async { (c) in
            Box.f.receiveAll(c)
        }
    }

    override func tearDown() {
        async { (c) in
            Box.f.receiveAll(c)
        }
        super.tearDown()
    }

    func testExample() {
        
        async { (c) in
//            let address = Box.testWallet.firstAccount.address
//            let amount = Balance(value: BigInt("1000000000000000000")!)
//            printLog("start")
//            
//            Box.f.sendViteToSelf(account: Box.testWallet.firstAccount, amount: firstAmount)
//                .then { ret -> Promise<Void> in
//                    printLog("send self \(ret.amount!.value.description)")
//                    return Promise.value(())
//                }.then { () -> Promise<AccountBlock> in
//                    return Box.f.sendViteToSelf(account: Box.testWallet.firstAccount, amount: secondAmount)
//                }.then { ret -> Promise<Void> in
//                    printLog("send self \(ret.amount!.value.description)")
//                    return Promise.value(Void())
//                }.then { () -> Promise<[AccountBlock]> in
//                    return GetOnroadBlocksRequest(address: address.description, index: 0, count: 10).defaultProviderPromise
//                }.then { ret -> Promise<[OnroadInfo]> in
//                    XCTAssert(ret.count == 2)
//                    let first = ret[0]
//                    let second = ret[1]
//                    XCTAssert(first.amount?.value == firstAmount.value)
//                    XCTAssert(second.amount?.value == secondAmount.value)
//                    return GetOnroadInfosRequest(address: address.description).defaultProviderPromise
//                }.done { ret in
////                    XCTAssert(ret.count == 1)
////                    let info = ret[0]
////                    XCTAssert(info.unconfirmedCount == 2)
////                    XCTAssert(info.unconfirmedBalance.value == (firstAmount.value + secondAmount.value))
//                }.catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    printLog("end")
//                    c()
//            }
        }
    }
}
