//
//  ViteNode+Tx.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.mintage {

    static func getToken(tokenId: String) -> Promise<Token> {
        return GetTokenInfoRequest(tokenId: tokenId).defaultProviderPromise
    }
}
