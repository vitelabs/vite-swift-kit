//
//  GetBalanceInfosRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetBalanceInfosRequest: JSONRPCKit.Request {
    public typealias Response = [BalanceInfo]

    let address: String

    public var method: String {
        return "ledger_getAccountByAccAddr"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: String) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {

        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var balanceInfoArray = [[String: Any]]()
        if let map = response["tokenBalanceInfoMap"] as?  [String: Any],
            let array = Array(map.values) as? [[String: Any]] {
            balanceInfoArray = array
        }

        let balanceInfos = balanceInfoArray.map({ BalanceInfo(JSON: $0) })
        let ret = balanceInfos.compactMap { $0 }
        return ret
    }
}
