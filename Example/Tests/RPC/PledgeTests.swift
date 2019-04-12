//
//  PledgeTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class PledgeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
        async { (c) in
            Box.f.makeSureHasEnoughViteAmount(account: Box.testWallet.secondAccount)
                .done({ (_) in
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
            let account = Box.testWallet.secondAccount
            let address = account.address
            let amount = Balance(value: BigInt("1000000000000000000000")!)

            func pledge() -> Promise<Void> {
                return ViteNode.pledge.perform.getPow(account: account, beneficialAddress: address, amount: amount)
                    .then({ (context) -> Promise<Void> in
                        return ViteNode.rawTx.send.context(context).mapToVoid()
                    }).then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasQuota(address: address)
                    })
            }

            func cancelPledge() -> Promise<Void> {
                return ViteNode.pledge.cancel.withoutPow(account: account, beneficialAddress: address, amount: amount).mapToVoid()
                    .then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasNoQuota(address: address)
                    })
            }

            func getPledgeInfo() -> Promise<(Quota, PledgeDetail, Balance)> {
                return ViteNode.pledge.info.getPledgeQuota(address: address)
                    .then({ (quota) -> Promise<(Quota, PledgeDetail)> in
                        return ViteNode.pledge.info.getPledgeDetail(address: address, index: 0, count: 10).map({ (quota, $0) })
                    }).then({ (quota, pledges) -> Promise<(Quota, PledgeDetail, Balance)> in
                        return ViteNode.pledge.info.getPledgeBeneficialAmount(address: address).map({ (quota, pledges, $0) })
                    })
            }

            firstly(execute: { () -> Promise<Void> in
                printLog("🚀makeSureHasNoPledge")
                return Box.f.makeSureHasNoPledge(account: account)
            }).then({ () -> Promise<Void> in
                printLog("✅makeSureHasNoPledge")
                printLog("🚀pledge")
                return pledge()
            }).then({ () -> Promise<(Quota, PledgeDetail, Balance)> in
                printLog("✅pledge")
                printLog("🚀getPledgeInfo")
                return getPledgeInfo()
            }).then({ (quota, pledgeDetail, balance) -> Promise<Void> in
                XCTAssert(quota.total > 0)
                XCTAssert(pledgeDetail.totalCount == 1)
                XCTAssert(pledgeDetail.totalPledgeAmount.value == amount.value)
                var pledgeAmount = Balance()
                for pledge in pledgeDetail.list where pledge.beneficialAddress.description == address.description {
                    pledgeAmount = pledge.amount
                }
                XCTAssert(pledgeAmount.value == amount.value)
                XCTAssert(amount.value == balance.value)
                printLog("✅getPledgeInfo")
                printLog("🚀cancelPledge")
                return cancelPledge()
            }).then({ () -> Promise<(Quota, PledgeDetail, Balance)> in
                printLog("✅cancelPledge")
                printLog("🚀getPledgeInfo")
                return getPledgeInfo()
            }).then({ (quota, pledgeDetail, balance) -> Promise<Void> in
                XCTAssert(quota.total == 0)
                XCTAssert(quota.current == 0)
                XCTAssert(quota.utps == 0)
                XCTAssert(pledgeDetail.totalCount == 0)
                XCTAssert(pledgeDetail.totalPledgeAmount.value == 0)
                var success = true
                for pledge in pledgeDetail.list where pledge.beneficialAddress.description == address.description {
                    success = false
                }
                XCTAssert(success)
                XCTAssert(balance.value == 0)
                printLog("✅getPledgeInfo")
                printLog("🚀pledge")
                return pledge()
            }).done({ (_) in
                printLog("✅pledge")
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally {
                c()
            }
        }
    }

}
