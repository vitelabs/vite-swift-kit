//
//  ViteNode+Utils.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/10.
//

import Foundation

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.utils {
    public struct receive {}
}

public extension ViteNode.utils.receive {

    static func latestRawTxIfHasWithoutPow(account: Wallet.Account) -> Promise<AccountBlockPair?> {
        return GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1).defaultProviderPromise
            .then { onroadBlocks -> Promise<AccountBlockPair?> in
                guard let onroadBlock = onroadBlocks.first else { return Promise.value(nil) }
                return ViteNode.rawTx.receive.withoutPow(account: account, onroadBlock: onroadBlock).map { block -> AccountBlockPair? in AccountBlockPair(send: onroadBlock, receive: block) }
        }
    }

    static func latestRawTxIfHasWithPow(account: Wallet.Account) -> Promise<AccountBlockPair?> {
        return GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1).defaultProviderPromise
            .then { onroadBlocks -> Promise<ReceiveBlockContext?> in
                guard let onroadBlock = onroadBlocks.first else { return Promise.value(nil) }
                return ViteNode.rawTx.receive.getPow(account: account, onroadBlock: onroadBlock).map { context -> ReceiveBlockContext? in context }
            }
            .then { context -> Promise<AccountBlockPair?> in
                guard let context = context else { return Promise.value(nil) }
                return ViteNode.rawTx.receive.context(context).map { block -> AccountBlockPair? in AccountBlockPair(send: context.onroadBlock, receive: block) }
        }
    }
}

public extension ViteNode.utils {

    static func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
        let batch = BatchFactory().create(GetBalanceInfosRequest(address: address.description),
                                          GetOnroadInfosRequest(address: address.description))
        return RPCRequest(for: Provider.default.server, batch: batch).promise.map { BalanceInfo.mergeBalanceInfos($0, onroadInfos: $1) }
    }


    static func recoverAddresses(_ addresses: [Address]) -> Promise<Int> {
        guard addresses.count == 10 else { fatalError() }

        func makePromise(startIndex: Int) -> Promise<Int?> {
            let start = startIndex
            let mid = start + 1
            let end = mid + 1

            return RPCRequest(for: Provider.default.server, batch: BatchFactory()
                .create(request1: GetBalanceInfosRequest(address: addresses[start].description),
                        GetOnroadInfosRequest(address: addresses[start].description),
                        GetBalanceInfosRequest(address: addresses[mid].description),
                        GetOnroadInfosRequest(address: addresses[mid].description),
                        GetBalanceInfosRequest(address: addresses[end].description),
                        GetOnroadInfosRequest(address: addresses[end].description))).promise
                .map { (bStart, uStart, bMid, uMid, bEnd, uEnd) -> Int? in
                    let s = BalanceInfo.mergeBalanceInfos(bStart, onroadInfos: uStart)
                    let m = BalanceInfo.mergeBalanceInfos(bMid, onroadInfos: uMid)
                    let e = BalanceInfo.mergeBalanceInfos(bEnd, onroadInfos: uEnd)
                    if !e.isEmpty {
                        return end
                    } else if !m.isEmpty {
                        return mid
                    } else if !s.isEmpty {
                        return start
                    } else {
                        return nil
                    }
            }
        }

        let p123 = makePromise(startIndex: 1)
        let p456 = makePromise(startIndex: 4)
        let p789 = makePromise(startIndex: 7)

        return when(fulfilled: p123, p456, p789)
            .map { (p1, p4, p7) -> Int in
                let count = (p7 ?? p4 ?? p1 ?? 0) + 1
                return count
        }
    }
}
