//
//  MintageTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/4/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ViteWallet
import BigInt
import PromiseKit

class MintageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Box.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAll() {
        
        async { (c) in

            firstly(execute: { () -> Promise<Token> in
                return ViteNode.mintage.getToken(tokenId: ViteWalletConst.viteToken.id)
            }).done({ (token) in
                XCTAssert(ViteWalletConst.viteToken.id == token.id)
                XCTAssert(ViteWalletConst.viteToken.name == token.name)
                XCTAssert(ViteWalletConst.viteToken.symbol == token.symbol)
                XCTAssert(ViteWalletConst.viteToken.decimals == token.decimals)
                XCTAssert(ViteWalletConst.viteToken.decimals == token.decimals)

                XCTAssert(ViteWalletConst.viteToken.index == token.index)
                XCTAssert(ViteWalletConst.viteToken.totalSupply == token.totalSupply)
                XCTAssert(ViteWalletConst.viteToken.maxSupply == token.maxSupply)
                XCTAssert(ViteWalletConst.viteToken.owner == token.owner)
                XCTAssert(ViteWalletConst.viteToken.ownerBurnOnly == token.ownerBurnOnly)
                XCTAssert(ViteWalletConst.viteToken.isReIssuable == token.isReIssuable)
            }).catch({ (error) in
                printLog(error)
                XCTAssert(false)
            }).finally {
                c()
            }
        }
    }

}
