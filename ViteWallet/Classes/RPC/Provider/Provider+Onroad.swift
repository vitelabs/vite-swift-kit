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

    public func getOnroadInfos(address: Address) -> Promise<[OnroadInfo]> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetOnroadInfosRequest(address: address.description))).promise
    }

    public func getOnroaBlocks(address: Address, index: Int, count: Int) -> Promise<[AccountBlock]> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetOnroadBlocksRequest(address: address.description, index: index, count: count))).promise
    }
}
