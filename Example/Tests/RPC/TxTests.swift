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
            firstly(execute: { () -> Promise<Amount> in
                return Box.f.makeSureHasEnoughViteAmount(account: Box.testWallet.firstAccount)
            }).then({ (_) -> Promise<Amount> in
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

    func testWithPow() {
        
        async { (c) in
            let account = Box.testWallet.firstAccount
            let address = account.address
            let tokenId = ViteWalletConst.viteToken.id
            let amount = Amount("1000000000000000000")!
            let data = Data("00112233aabbcc".hex2Bytes)

            firstly(execute: { () -> Promise<Void> in
                printLog("start")
                printLog("=============== send with pow ===============")
                printLog("🚀 tx_calcPoWDifficulty")
                return Box.f.makeSureHasNoPledge(account: account)
            }).then({ (_) -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account, toAddress: address, tokenId: tokenId, amount: amount, data: data)
            }).then({ (context) -> Promise<AccountBlock> in
                printLog("✅tx_calcPoWDifficulty")
                printLog("🚀tx_sendRawTx")
                return ViteNode.rawTx.send.context(context)
            }).then({ (_) -> Promise<AccountBlock> in
                printLog("✅tx_sendRawTx")
                return Box.f.afterLatestAccountBlockConfirmed(address: address)
            }).then({ (accountBlock) -> Promise<[AccountBlock]> in
                XCTAssert(accountBlock.toAddress == address)
                XCTAssert(accountBlock.tokenId == tokenId)
                XCTAssert(accountBlock.amount == amount)
                XCTAssert(accountBlock.data == data)
                printLog("=============== receive with pow ===============")
                return ViteNode.onroad.getOnroadBlocks(address: account.address, index: 0, count: 1)
            }).then({ (accountBlocks) -> Promise<ReceiveBlockContext> in
                XCTAssert(accountBlocks.count == 1)
                let accountBlock = accountBlocks[0]
                printLog("🚀 tx_calcPoWDifficulty")
                return ViteNode.rawTx.receive.getPow(account: account, onroadBlock: accountBlock)
            }).then({ (context) -> Promise<AccountBlock> in
                printLog("✅tx_calcPoWDifficulty")
                printLog("🚀tx_sendRawTx")
                return ViteNode.rawTx.receive.context(context)
            }).then({ (_) -> Promise<AccountBlock> in
                printLog("✅tx_sendRawTx")
                return Box.f.afterLatestAccountBlockConfirmed(address: address)
            }).then({ (_) -> Promise<[AccountBlock]> in
                return ViteNode.onroad.getOnroadBlocks(address: account.address, index: 0, count: 1)
            }).done({ (accountBlocks) in
                XCTAssert(accountBlocks.count == 0)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally({
                printLog("end")
                c()
            })
        }
    }

    func testWithoutPow() {

        async { (c) in
            let account = Box.testWallet.secondAccount
            let address = account.address
            let tokenId = ViteWalletConst.viteToken.id
            let amount = Amount("1000000000000000000")!
            let data = Data("00112233aabbcc".hex2Bytes)


            firstly(execute: { () -> Promise<Amount> in
                printLog("start")
                return Box.f.makeSureHasPledge(account: account)
            }).then({ (_) -> Promise<Quota> in
                return ViteNode.pledge.info.getPledgeQuota(address: address)
            }).then({ (quota) -> Promise<AccountBlock> in
                XCTAssert(quota.utps > 0, "❌ need pledge")
                printLog("=============== send without pow ===============")
                printLog("🚀tx_sendRawTx")
                return ViteNode.rawTx.send.withoutPow(account: account, toAddress: address, tokenId: tokenId, amount: amount, data: data)
            }).then({ (_) -> Promise<AccountBlock> in
                printLog("✅tx_sendRawTx")
                return Box.f.afterLatestAccountBlockConfirmed(address: address)
            }).then({ (accountBlock) -> Promise<[AccountBlock]> in
                XCTAssert(accountBlock.toAddress == address)
                XCTAssert(accountBlock.tokenId == tokenId)
                XCTAssert(accountBlock.amount == amount)
                XCTAssert(accountBlock.data == data)
                printLog("=============== receive without pow ===============")
                return ViteNode.onroad.getOnroadBlocks(address: account.address, index: 0, count: 1)
            }).then({ (accountBlocks) -> Promise<AccountBlock> in
                XCTAssert(accountBlocks.count == 1)
                let accountBlock = accountBlocks[0]
                printLog("🚀 tx_sendRawTx")
                return ViteNode.rawTx.receive.withoutPow(account: account, onroadBlock: accountBlock)
            }).then({ (_) -> Promise<AccountBlock> in
                printLog("✅tx_sendRawTx")
                return Box.f.afterLatestAccountBlockConfirmed(address: address)
            }).then({ (_) -> Promise<[AccountBlock]> in
                return ViteNode.onroad.getOnroadBlocks(address: account.address, index: 0, count: 1)
            }).done({ (accountBlocks) in
                XCTAssert(accountBlocks.count == 0)
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
