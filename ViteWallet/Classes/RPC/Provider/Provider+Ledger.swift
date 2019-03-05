//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit
import PromiseKit

extension Provider {

    public func getSnapshotChainHeight() -> Promise<UInt64> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetSnapshotChainHeightRequest())).promise
    }

    public func getToken(for id: String) -> Promise<Token> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTokenInfoRequest(tokenId: id))).promise
    }

    public func getTestToken(address: Address) -> Promise<Balance> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTestTokenRequest(address: address.description))).promise
    }

    public func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
        let batch = BatchFactory().create(GetBalanceInfosRequest(address: address.description),
                                          GetOnroadInfosRequest(address: address.description))
        return RPCRequest(for: server, batch: batch).promise
            .map { BalanceInfo.mergeBalanceInfos($0, onroadInfos: $1) }
    }

    public func getOnroadInfos(address: Address) -> Promise<[OnroadInfo]> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetOnroadInfosRequest(address: address.description))).promise
    }

    public func getTransactions(address: Address, hash: String?, count: Int) -> Promise<(transactions: [Transaction], nextHash: String?)> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTransactionsRequest(address: address.description, hash: hash, count: count))).promise
    }

    public func getTokenTransactions(address: Address, hash: String?, tokenId: String, count: Int) -> Promise<(transactions: [Transaction], nextHash: String?)> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTokenTransactionsRequest(address: address.description, hash: hash, tokenId: tokenId, count: count))).promise
    }
}
