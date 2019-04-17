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

    static func getOnroadBlocks(address: ViteAddress, index: Int, count: Int) -> Promise<[AccountBlock]> {
        return GetOnroadBlocksRequest(address: address, index: index, count: count).defaultProviderPromise
    }

    static func getOnroadInfos(address: ViteAddress) -> Promise<[OnroadInfo]> {
        return GetOnroadInfosRequest(address: address).defaultProviderPromise
    }
}
