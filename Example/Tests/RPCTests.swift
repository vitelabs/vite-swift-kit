//
//  RPCTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2018/12/10.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import JSONRPCKit
import BigInt

class RPCTests: XCTestCase {

    let viteTokenId = ViteWalletConst.viteToken.id
    let encryptedKey = "123456"

    lazy var  wallet: Wallet = {
        let mnemonic = "nuclear buzz drift segment state heavy leaf pistol frozen casual wall kit pitch feel prevent donor idea track oil inside have lens purity wisdom"
        let wallet = Wallet(uuid: "1", name: "2", mnemonic: mnemonic, language: .english, encryptedKey: self.encryptedKey)
        return wallet
    }()

    lazy var firstAccount = try! self.wallet.account(at: 0, encryptedKey: self.encryptedKey)
    lazy var secondAccount = try! self.wallet.account(at: 1, encryptedKey: self.encryptedKey)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Provider.default.update(server: RPCServer(url: URL(string: "http://45.40.197.46:48132")!))
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
        print("🍺🍺🍺🍺🍺🍺")

    }

    func testGetSnapshotChainHeight() {
        async { (completion) in
            Provider.default.getSnapshotChainHeight()
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetToken() {
        async { (completion) in
            Provider.default.getToken(for: viteTokenId)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetTestToken() {
        async { (completion) in
            Provider.default.getTestToken(address: firstAccount.address)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetBalanceInfos() {
        async { (completion) in
            Provider.default.getBalanceInfos(address: firstAccount.address)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetTransactions() {
        async { (completion) in
            Provider.default.getTransactions(address: firstAccount.address, hash: nil, count: 11)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func test() {
        let addresses = (0..<10).map { try! wallet.account(at: $0, encryptedKey: encryptedKey).address }

        async { (completion) in
            Provider.default.recoverAddresses(addresses)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testReceiveTransactionWithoutPow() {
        async { (completion) in
            Provider.default.receiveLatestTransactionIfHasWithoutPow(account: secondAccount)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testReceiveTransactionWithPow() {
        async { (completion) in
            Provider.default.receiveLatestTransactionIfHasWithPow(account: secondAccount, difficulty: ViteWalletConst.DefaultDifficulty.receive.value)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testSendTransactionWithoutPow() {
        let amount = BigInt("1000000000000000000")!
        let note = "hahaha"
        async { (completion) in
            Provider.default.sendTransactionWithoutPow(account: secondAccount,
                                                       toAddress: secondAccount.address,
                                                       tokenId: viteTokenId,
                                                       amount: amount,
                                                       note: note)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testSendTransactionWithPow() {
        let amount = BigInt("1000000000000000000")!
        let note = "hahaha"
        async { (completion) in
            Provider.default.sendTransactionWithPow(account: secondAccount,
                                                    toAddress: secondAccount.address,
                                                    tokenId: viteTokenId,
                                                    amount: amount,
                                                    note: note,
                                                    difficulty: ViteWalletConst.DefaultDifficulty.send.value)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetPledges() {
        async { (completion) in
            Provider.default.getPledges(address: firstAccount.address, index: 0, count: 10)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testPledgeWithoutPow() {
        let amount = BigInt("10000000000000000000")!
        async { (completion) in
            Provider.default.pledgeWithoutPow(account: firstAccount, beneficialAddress: firstAccount.address, amount: amount)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testPledgeWithPow() {
        let amount = BigInt("10000000000000000000")!
        async { (completion) in
            Provider.default.pledgeWithPow(account: firstAccount, beneficialAddress: firstAccount.address, amount: amount, difficulty: ViteWalletConst.DefaultDifficulty.pledge.value)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
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
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testGetVoteInfo() {
        async { (completion) in
            Provider.default.getVoteInfo(gid: ViteWalletConst.ConsensusGroup.snapshot.id, address: secondAccount.address)
                .done { (ret) in
                    if let ret = ret {
                        print(ret)
                    } else {
                        print("nil")
                    }
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testVoteWithoutPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.voteWithoutPow(account: firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testVoteWithPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.voteWithPow(account: secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name, difficulty: ViteWalletConst.DefaultDifficulty.vote.value)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testCancelVoteWithoutPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.cancelVoteWithoutPow(account: firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }

    func testCancelVoteWithPow() {
        let name = "Han"
        async { (completion) in
            Provider.default.cancelVoteWithPow(account: secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name, difficulty: ViteWalletConst.DefaultDifficulty.cancelVote.value)
                .done { (ret) in
                    print(ret)
                }
                .catch { (error) in
                    print(error)
                    XCTAssert(false)
                }.finally {
                    completion()
            }
        }
    }
}
