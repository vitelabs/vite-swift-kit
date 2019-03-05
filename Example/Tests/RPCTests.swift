//
//  RPCTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2018/12/10.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class RPCTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Provider.default.update(server: RPCServer(url: URL(string: "http://45.40.197.46:48132")!))
        LogConfig.instance.isEnable = true
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func async(_ block: ( @escaping () -> () ) -> ()) {

        let expect = expectation(description: "method")
        block {
            expect.fulfill()
        }
        waitForExpectations(timeout: 6000000, handler: nil)
        printLog("🍺🍺🍺🍺🍺🍺")

    }

    func testGetSnapshotChainHeight() {
        async { (completion) in
            Provider.default.getSnapshotChainHeight()
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetToken() {
        async { (completion) in
            Provider.default.getToken(for: Box.viteTokenId)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetTestToken() {
        async { (completion) in
            Provider.default.getTestToken(address: Box.firstAccount.address)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetBalanceInfos() {
        async { (completion) in
            Provider.default.getBalanceInfos(address: Box.firstAccount.address)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetTransactions() {
        async { (completion) in
            Provider.default.getTransactions(address: Box.firstAccount.address, hash: nil, count: 11)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func test() {
        let addresses = (0..<10).map { try! Box.wallet.account(at: $0, encryptedKey: Box.encryptedKey).address }

        async { (completion) in
            Provider.default.recoverAddresses(addresses)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testReceiveTransactionWithoutPow() {
        async { (completion) in
            Provider.default.receiveLatestTransactionIfHasWithoutPow(account: Box.secondAccount)
                .done { (ret) in
                    if let ret = ret {
                        printLog(ret)
                    } else {
                        printLog("Don't need receive")
                    }
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testReceiveTransactionWithPow() {
        async { (completion) in
            Provider.default.receiveLatestTransactionIfHasWithPow(account: Box.secondAccount)
                .done { (ret) in
                    if let ret = ret {
                        printLog(ret)
                    } else {
                        printLog("Don't need receive")
                    }
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testSendTransactionWithoutPow() {
        let amount = Balance(value: BigInt("1000000000000000000")!)
        let note = "hahaha"
        async { (completion) in
            Provider.default.sendTransactionWithoutPow(account: Box.secondAccount,
                                                       toAddress: Box.secondAccount.address,
                                                       tokenId: Box.viteTokenId,
                                                       amount: amount,
                                                       note: note)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testSendTransactionWithPow() {
        let amount = Balance(value: BigInt("1000000000000000000")!)
        let note = "hahaha"
        async { (completion) in
            Provider.default.getPowForSendTransaction(account: Box.secondAccount,
                                                    toAddress: Box.secondAccount.address,
                                                    tokenId: Box.viteTokenId,
                                                    amount: amount,
                                                    note: note)
                .then { context -> Promise<AccountBlock> in
                    return Provider.default.sendRawTxWithContext(context)
                }
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetPledges() {
        async { (completion) in
            Provider.default.getPledges(address: Box.firstAccount.address, index: 0, count: 10)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetPledgeQuota() {
        async { (completion) in
            Provider.default.getPledgeQuota(address: Box.firstAccount.address)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testPledgeWithoutPow() {
        let amount = Balance(value: BigInt("10000000000000000000")!)
        async { (completion) in
            Provider.default.pledgeWithoutPow(account: Box.firstAccount, beneficialAddress: Box.firstAccount.address, amount: amount)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testPledgeWithPow() {
        let amount = Balance(value: BigInt("10000000000000000000")!)
        async { (completion) in
            Provider.default.getPowForPledge(account: Box.firstAccount, beneficialAddress: Box.firstAccount.address, amount: amount)
                .then { context -> Promise<AccountBlock> in
                    return Provider.default.sendRawTxWithContext(context)
                }
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetCandidateList() {
        async { (completion) in
            Provider.default.getCandidateList(gid: ViteWalletConst.ConsensusGroup.snapshot.id)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetVoteInfo() {
        async { (completion) in
            Provider.default.getVoteInfo(gid: ViteWalletConst.ConsensusGroup.snapshot.id, address: Box.secondAccount.address)
                .done { (ret) in
                    if let ret = ret {
                        printLog(ret)
                    } else {
                        printLog("nil")
                    }
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testVoteWithoutPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.voteWithoutPow(account: Box.firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testVoteWithPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.getPowForVote(account: Box.secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
                .then { context -> Promise<AccountBlock> in
                    return Provider.default.sendRawTxWithContext(context)
                }
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testCancelVoteWithoutPow() {
        async { (completion) in
            Provider.default.cancelVoteWithoutPow(account: Box.firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id)
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testCancelVoteWithPow() {
        async { (completion) in
            Provider.default.getPowForCancelVote(account: Box.secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id)
                .then { context -> Promise<AccountBlock> in
                    return Provider.default.sendRawTxWithContext(context)
                }
                .done { (ret) in
                    printLog(ret)
                }
                .catch { (error) in
                    printLog(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }
}
