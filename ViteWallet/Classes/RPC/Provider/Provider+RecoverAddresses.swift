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
import BigInt

extension Provider {
    public func recoverAddresses(_ addresses: [Address]) -> Promise<Int> {
        guard addresses.count == 10 else { fatalError() }

        func makePromise(startIndex: Int) -> Promise<Int?> {
            let start = startIndex
            let mid = start + 1
            let end = mid + 1

            return RPCRequest(for: server, batch: BatchFactory()
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
