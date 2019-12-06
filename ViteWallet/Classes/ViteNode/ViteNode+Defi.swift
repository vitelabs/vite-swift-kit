//
//  ViteNode+Defi.swift
//  Action
//
//  Created by haoshenyang on 2019/12/6.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.defi {
    public struct info {}
    public struct perform {}
}

public extension ViteNode.defi.info {
    static func getDefiAccountInfo(address: ViteAddress, tokenId: ViteTokenId) -> Promise<DefiAccountInfo?> {
        return DefiAccountInfoRequest(address: address, tokenId: tokenId).defaultProviderPromise
    }

    static func getDefiLoanInfo(id: Int) -> Promise<DeFiLoanInfo?> {
        return DefiLoanInfoRequest(id: id).defaultProviderPromise
    }

    static func getDefiSubscriptionInfo(id: Int) -> Promise<DefiSubscriptionInfo?> {
        return DefiSubscriptionInfoRequest(id: id).defaultProviderPromise
    }
}
