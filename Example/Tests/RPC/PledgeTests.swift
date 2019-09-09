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
            firstly(execute: { () -> Promise<Amount> in
                return Box.f.makeSureHasEnoughViteAmount(account: Box.testWallet.secondAccount)
            }).done({ (_) in
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
            let amount = Amount("1000000000000000000000")!

            func pledge() -> Promise<Void> {
                return ViteNode.pledge.perform.getPow(account: account, beneficialAddress: address, amount: amount)
                    .then({ (context) -> Promise<Void> in
                        return ViteNode.rawTx.send.context(context).asVoid()
                    }).then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasQuota(address: address)
                    })
            }

            func cancelPledge() -> Promise<Void> {
                return ViteNode.pledge.cancel.withoutPow(account: account, beneficialAddress: address, amount: amount).asVoid()
                    .then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasNoQuota(address: address)
                    })
            }

            func getPledgeInfo() -> Promise<(Quota, PledgeDetail, Amount)> {
                return ViteNode.pledge.info.getPledgeQuota(address: address)
                    .then({ (quota) -> Promise<(Quota, PledgeDetail)> in
                        return ViteNode.pledge.info.getPledgeDetail(address: address, index: 0, count: 10).map({ (quota, $0) })
                    }).then({ (quota, pledges) -> Promise<(Quota, PledgeDetail, Amount)> in
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
            }).then({ () -> Promise<(Quota, PledgeDetail, Amount)> in
                printLog("✅pledge")
                printLog("🚀getPledgeInfo")
                return getPledgeInfo()
            }).then({ (quota, pledgeDetail, balance) -> Promise<Void> in
                XCTAssert(quota.quotaPerSnapshotBlock > 0)
                XCTAssert(pledgeDetail.totalCount == 1)
                XCTAssert(pledgeDetail.totalPledgeAmount == amount)
                var pledgeAmount = Amount()
                for pledge in pledgeDetail.list where pledge.beneficialAddress == address {
                    pledgeAmount = pledge.amount
                }
                XCTAssert(pledgeAmount == amount)
                XCTAssert(amount == balance)
                printLog("✅getPledgeInfo")
                printLog("🚀cancelPledge")
                return cancelPledge()
            }).then({ () -> Promise<(Quota, PledgeDetail, Amount)> in
                printLog("✅cancelPledge")
                printLog("🚀getPledgeInfo")
                return getPledgeInfo()
            }).then({ (quota, pledgeDetail, balance) -> Promise<Void> in
                XCTAssert(quota.quotaPerSnapshotBlock == 0)
                XCTAssert(quota.currentQuota == 0)
                XCTAssert(quota.utpe == 0)
                XCTAssert(quota.currentUt == 0)
                XCTAssert(quota.pledgeAmount == 0)
                XCTAssert(pledgeDetail.totalCount == 0)
                XCTAssert(pledgeDetail.totalPledgeAmount == 0)
                var success = true
                for pledge in pledgeDetail.list where pledge.beneficialAddress == address {
                    success = false
                }
                XCTAssert(success)
                XCTAssert(balance == 0)
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
