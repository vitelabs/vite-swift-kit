//
//  ViteNode+Onroad.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.onroad {

    static func getOnroadBlocks(address: Address, index: Int, count: Int) -> Promise<[AccountBlock]> {
        return GetOnroadBlocksRequest(address: address.description, index: index, count: count).defaultProviderPromise
    }

    static func getOnroadInfos(address: Address) -> Promise<[OnroadInfo]> {
        return GetOnroadInfosRequest(address: address.description).defaultProviderPromise
    }
}
