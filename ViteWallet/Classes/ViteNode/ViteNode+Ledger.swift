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
    static func getBalanceInfosWithoutOnroad(address: ViteAddress) -> Promise<[BalanceInfo]> {
        return GetBalanceInfosRequest(address: address).defaultProviderPromise
    }

    static func getLatestAccountBlock(address: ViteAddress) -> Promise<AccountBlock?> {
        return GetLatestAccountBlockRequest(address: address).defaultProviderPromise
    }

    static func getAccountBlock(hash: String) -> Promise<AccountBlock?> {
        return GetAccountBlockByHashRequest(hash: hash).defaultProviderPromise
    }

    static func getAccountBlocks(address: ViteAddress, hash: String?, count: Int) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> {
        return GetAccountBlocksByHashRequest(address: address, hash: hash, count: count).defaultProviderPromise
    }

    static func getAccountBlocks(address: ViteAddress, tokenId: String, hash: String?, count: Int) -> Promise<(accountBlocks: [AccountBlock], nextHash: String?)> {
        return GetAccountBlocksByHashInTokenRequest(address: address, tokenId: tokenId, hash: hash, count: count).defaultProviderPromise
    }

    static func getSnapshotChainHeight() -> Promise<UInt64> {
        return GetSnapshotChainHeightRequest().defaultProviderPromise
    }
}
