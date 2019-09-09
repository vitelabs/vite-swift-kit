//
//  GetDexBalanceInfosRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetDexBalanceInfosRequest: JSONRPCKit.Request {
    public typealias Response = [DexBalanceInfo]

    let address: ViteAddress
    let tokenId: ViteTokenId?

    public var method: String {
        return "dexfund_getAccountFundInfo"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress, tokenId: ViteTokenId?) {
        self.address = address
        self.tokenId = tokenId
    }

    public func response(from resultObject: Any) throws -> Response {

        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var balanceInfoArray = [[String: Any]]()
        if let array = Array(response.values) as? [[String: Any]] {
            balanceInfoArray = array
        }

        let balanceInfos = balanceInfoArray.map({ DexBalanceInfo(JSON: $0) })
        let ret = balanceInfos.compactMap { $0 }
        return ret
    }
}
