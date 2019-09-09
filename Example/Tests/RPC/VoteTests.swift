//
//  VoteTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class VoteTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
        async { (c) in
            firstly(execute: { () -> Promise<Amount> in
                return Box.f.makeSureHasEnoughViteAmount(account: Box.testWallet.firstAccount)
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
            let account = Box.testWallet.firstAccount
            let address = account.address

            var nodeName = ""

            func vote() -> Promise<Void> {
                return ViteNode.vote.info.getCandidateList(gid: ViteWalletConst.ConsensusGroup.snapshot.id)
                    .then({ (candidates) -> Promise<SendBlockContext> in
                        nodeName = candidates[0].name
                        return ViteNode.vote.perform.getPow(account: account, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: nodeName)
                    }).then({ (context) -> Promise<Void> in
                        return ViteNode.rawTx.send.context(context).asVoid()
                    }).then({ (_) -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: account.address).asVoid()
                    }).then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasVoteInfo(address: address)
                    })
            }

            func cancelVote() -> Promise<Void> {
                return ViteNode.vote.cancel.getPow(account: account, gid: ViteWalletConst.ConsensusGroup.snapshot.id)
                    .then({ (context) -> Promise<Void> in
                        return ViteNode.rawTx.send.context(context).asVoid()
                    }).then({ (_) -> Promise<Void> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: account.address).asVoid()
                    }).then({ () -> Promise<Void> in
                        return Box.f.watiUntilHasNoVoteInfo(address: address)
                    })
            }

            firstly(execute: { () -> Promise<Void> in
                printLog("🚀vote")
                return vote()
            }).then({ () -> Promise<VoteInfo?> in
                printLog("✅vote")
                printLog("🚀getVoteInfo")
                return ViteNode.vote.info.getVoteInfo(gid: ViteWalletConst.ConsensusGroup.snapshot.id, address: address)
            }).then({ (voteInfo) -> Promise<Void> in
                XCTAssert(voteInfo != nil)
                XCTAssert(voteInfo?.nodeName == nodeName)
                printLog("✅getVoteInfo")
                printLog("🚀cancelVote")
                return cancelVote()
            }).then({ () -> Promise<VoteInfo?> in
                printLog("✅cancelVote")
                printLog("🚀getVoteInfo")
                return ViteNode.vote.info.getVoteInfo(gid: ViteWalletConst.ConsensusGroup.snapshot.id, address: address)
            }).done({ (voteInfo) in
                XCTAssert(voteInfo == nil)
                printLog("✅getVoteInfo")
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally {
                c()
            }
        }
    }

}
