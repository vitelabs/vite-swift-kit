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
        Provider.default.update(server: RPCServer(url: URL(string: "http://148.70.30.139:48132")!))
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

    

//    func testGetSnapshotChainHeight() {
//        async { (completion) in
//            Provider.default.getSnapshotChainHeight()
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetToken() {
//        async { (completion) in
//            Provider.default.getToken(for: Box.viteTokenId)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetTestToken() {
//        async { (completion) in
//            Provider.default.getTestToken(address: Box.firstAccount.address)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetBalanceInfos() {
//        async { (completion) in
//            Provider.default.getBalanceInfos(address: Box.secondAccount.address)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetTransactions() {
//        async { (completion) in
//            Provider.default.getTransactions(address: Box.secondAccount.address, hash: nil, count: 11)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func test() {
//        let addresses = (0..<10).map { try! Box.wallet.account(at: $0, encryptedKey: Box.encryptedKey).address }
//
//        async { (completion) in
//            Provider.default.recoverAddresses(addresses)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testReceiveTransactionWithoutPow() {
//        async { (completion) in
//            Provider.default.receiveLatestTransactionIfHasWithoutPow(account: Box.firstAccount)
//                .done { (ret) in
//                    if let ret = ret {
//                        printLog(ret)
//                    } else {
//                        printLog("Don't need receive")
//                    }
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testReceiveTransactionWithPow() {
//        async { (completion) in
//            Provider.default.receiveLatestTransactionIfHasWithPow(account: Box.firstAccount)
//                .done { (ret) in
//                    if let ret = ret {
//                        printLog(ret)
//                    } else {
//                        printLog("Don't need receive")
//                    }
//                }
//                .catch { (error) in
//                        printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
////    func testSign() {
////        let so = "2 233 165 144 122 39 129 112 140 43 97 84 176 112 170 84 59 120 140 223 80 204 70 112 26 54 112 57 82 51 155 100 240 0 0 0 0 0 0 0 123 64 236 208 104 230 145 150 148 217 137 134 110 51 98 197 87 152 79 210 99 170 1 199 130 137 213 24 98 2 109 147 201 129 21 228 181 64 184 0 168 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 232 86 73 84 69 32 84 79 75 69 78 238 152 190 201 49 103 150 17 161 34 154 53 114 49 186 29 55 190 11 24 154 85 48 46 156 93 143 71 81 254 168 244 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10 137 169 12 216 219 117 79 181 111 212 20 117 205 201 171 220 1 194 114 209 139 65 205 86 153 164 233 44 101 98 54 50 116 101 115 116 32 110 111 110 99 101 32 116 101 115 116 32 110 111 110 99 101"
////
////        let array = so.components(separatedBy: " ").map({ UInt8($0)!})
////        print(array.toHexString())
////
////        let json = "{\"blockType\":2,\"hash\":\"0000000000000000000000000000000000000000000000000000000000000000\",\"prevHash\":\"e9a5907a2781708c2b6154b070aa543b788cdf50cc46701a36703952339b64f0\",\"height\":\"123\",\"accountAddress\":\"vite_40ecd068e6919694d989866e3362c557984fd2637671219def\",\"publicKey\":\"kgRm0vB5ErdlkUoKKtZ4wYOIoSINDadMjtP2um/I2UU=\",\"toAddress\":\"vite_aa01c78289d51862026d93c98115e4b540b800a877aa98a76b\",\"amount\":\"1000\",\"tokenId\":\"tti_5649544520544f4b454e6e40\",\"fromBlockHash\":\"837fca7bc93835c635551971dc06abd440e2c590ec6f478847e3be392bb694bd\",\"data\":\"dGVzdCBkYXRhIHRlc3QgZGF0YQ==\",\"quota\":\"1234\",\"fee\":\"10\",\"logHash\":\"89a90cd8db754fb56fd41475cdc9abdc01c272d18b41cd5699a4e92c65623632\",\"difficulty\":\"10\",\"nonce\":\"dGVzdCBub25jZSB0ZXN0IG5vbmNl\",\"SendBlockList\":null,\"signature\":null}"
////        let accountBlock = AccountBlock(JSONString: json)!
////        AccountBlock.sign(accountBlock: accountBlock, secretKeyHexString: "", publicKeyHexString: "")
////    }
//
//    func testSendTransactionWithoutPow() {
//        let amount = Balance(value: BigInt("1000000000000000000")!)
//        let note = "first note"
//        async { (completion) in
//            Provider.default.sendTransactionWithoutPow(account: Box.secondAccount,
//                                                       toAddress: Address(string: "vite_847e1672c9a775ca0f3c3a2d3bf389ca466e5501cbecdb7107"),
//                                                       tokenId: Box.viteTokenId,
//                                                       amount: amount,
//                                                       note: note)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testSendTransactionWithPow() {
//        let amount = Balance(value: BigInt("100000000000000000000000")!)
//        let note = "hahaha"
//        async { (completion) in
//            Provider.default.getPowForSendTransaction(account: Box.secondAccount,
//                                                    toAddress: Address(string: "vite_847e1672c9a775ca0f3c3a2d3bf389ca466e5501cbecdb7107"),
//                                                    tokenId: Box.viteTokenId,
//                                                    amount: amount,
//                                                    note: note)
//                .then { context -> Promise<AccountBlock> in
//                    return Provider.default.sendRawTxWithContext(context)
//                }
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetPledges() {
//        async { (completion) in
//            Provider.default.getPledges(address: Box.firstAccount.address, index: 0, count: 10)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetPledgeQuota() {
//        async { (completion) in
//            Provider.default.getPledgeQuota(address: Box.firstAccount.address)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testPledgeWithoutPow() {
//        let amount = Balance(value: BigInt("10000000000000000000")!)
//        async { (completion) in
//            Provider.default.pledgeWithoutPow(account: Box.firstAccount, beneficialAddress: Box.firstAccount.address, amount: amount)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testPledgeWithPow() {
//        let amount = Balance(value: BigInt("10000000000000000000")!)
//        async { (completion) in
//            Provider.default.getPowForPledge(account: Box.firstAccount, beneficialAddress: Box.firstAccount.address, amount: amount)
//                .then { context -> Promise<AccountBlock> in
//                    return Provider.default.sendRawTxWithContext(context)
//                }
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetCandidateList() {
//        async { (completion) in
//            Provider.default.getCandidateList(gid: ViteWalletConst.ConsensusGroup.snapshot.id)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testGetVoteInfo() {
//        async { (completion) in
//            Provider.default.getVoteInfo(gid: ViteWalletConst.ConsensusGroup.snapshot.id, address: Box.secondAccount.address)
//                .done { (ret) in
//                    if let ret = ret {
//                        printLog(ret)
//                    } else {
//                        printLog("nil")
//                    }
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testVoteWithoutPow() {
//        let name = "Han"
//        async { (completion) in
//            Provider.default.voteWithoutPow(account: Box.firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testVoteWithPow() {
//        let name = "Han"
//        async { (completion) in
//            Provider.default.getPowForVote(account: Box.secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id, name: name)
//                .then { context -> Promise<AccountBlock> in
//                    return Provider.default.sendRawTxWithContext(context)
//                }
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testCancelVoteWithoutPow() {
//        async { (completion) in
//            Provider.default.cancelVoteWithoutPow(account: Box.firstAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id)
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
//
//    func testCancelVoteWithPow() {
//        async { (completion) in
//            Provider.default.getPowForCancelVote(account: Box.secondAccount, gid: ViteWalletConst.ConsensusGroup.snapshot.id)
//                .then { context -> Promise<AccountBlock> in
//                    return Provider.default.sendRawTxWithContext(context)
//                }
//                .done { (ret) in
//                    printLog(ret)
//                }
//                .catch { (error) in
//                    printLog(error)
//                    XCTAssert(false)
//                }.finally {
//                    completion()
//            }
//        }
//    }
}
