//
//  DexTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/9/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class DexTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAll() {
        async { (c) in

            let account = Box.testWallet.firstAccount
            let address = account.address
            let tokenId = ViteWalletConst.viteToken.id
            let amount = Amount("1000000000000000000")!

            firstly(execute: { () -> Promise<[DexBalanceInfo]> in
                return ViteNode.dex.info.getDexBalanceInfos(address: address, tokenId: tokenId)
            }).then({ (dexBalanceInfos) -> Promise<AccountBlock> in
                printLog(dexBalanceInfos[0].total)
                return ViteNode.rawTx.send.block(account: account,
                                                 toAddress: ViteWalletConst.ContractAddress.dexFund.address,
                                                 tokenId: tokenId,
                                                 amount: amount,
                                                 fee: nil,
                                                 data: ABI.BuildIn.getDexDeposit())
                    .then { (_) -> Promise<AccountBlock> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address)
                }
            }).then({ (_) -> Promise<[DexBalanceInfo]> in
                return ViteNode.dex.info.getDexBalanceInfos(address: address, tokenId: tokenId)
            }).then({ (dexBalanceInfos) -> Promise<AccountBlock> in
                printLog(dexBalanceInfos[0].total)
                return ViteNode.rawTx.send.block(account: account,
                                                 toAddress: ViteWalletConst.ContractAddress.dexFund.address,
                                                 tokenId: tokenId,
                                                 amount: 0,
                                                 fee: nil,
                                                 data: ABI.BuildIn.getDexWithdraw(tokenId: tokenId, amount: amount))
                    .then { (_) -> Promise<AccountBlock> in
                        return Box.f.afterLatestAccountBlockConfirmed(address: address)
                }
            }).then({ (_) -> Promise<[DexBalanceInfo]> in
                return ViteNode.dex.info.getDexBalanceInfos(address: address, tokenId: tokenId)
            }).done({ (dexBalanceInfos) in
                printLog(dexBalanceInfos[0].total)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally {
                c()
            }
        }
    }

}
