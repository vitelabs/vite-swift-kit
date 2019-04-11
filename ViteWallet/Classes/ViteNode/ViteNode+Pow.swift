//
//  ViteNode+Pow.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.pow {

    static func getNonce(address: Address, preHash: String?, difficulty: BigInt) -> Promise<String> {
        return GetPowNonceRequest(address: address, preHash: preHash, difficulty: difficulty).defaultProviderPromise
    }
}
