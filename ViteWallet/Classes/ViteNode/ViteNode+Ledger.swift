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

    static func getAccountBlock(hash: String) -> Promise<AccountBlock?> {
        return GetAccountBlockByHashRequest(hash: hash).defaultProviderPromise
    }

    static func getAccountBlocks(address: Address, hash: String?, count: Int) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> {
        return GetAccountBlocksByHashRequest(address: address.description, hash: hash, count: count).defaultProviderPromise
    }

    static func getAccountBlocks(address: Address, tokenId: String, hash: String?, count: Int) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> {
        return GetAccountBlocksByHashInTokenRequest(address: address.description, tokenId: tokenId, hash: hash, count: count).defaultProviderPromise
    }

    static func getSnapshotChainHeight() -> Promise<UInt64> {
        return GetSnapshotChainHeightRequest().defaultProviderPromise
    }
}
