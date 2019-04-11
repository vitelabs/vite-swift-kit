//
//  ViteNode+Ledger.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.ledger {

    // Usually use ViteNode.utils.getBalanceInfos
    static func getBalanceInfosWithoutOnroad(address: Address) -> Promise<[BalanceInfo]> {
        return GetBalanceInfosRequest(address: address.description).defaultProviderPromise
    }

    static func getLatestAccountBlock(address: Address) -> Promise<AccountBlock?> {
        return GetLatestAccountBlockRequest(address: address.description).defaultProviderPromise
    }
}
