//
//  GetUnconfirmedInfoRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetOnroadInfosRequest: JSONRPCKit.Request {
    public typealias Response = [OnroadInfo]

    let address: ViteAddress

    public var method: String {
        return "onroad_getOnroadInfoByAddress"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {

        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var onroadInfoArray = [[String: Any]]()
        if let map = response["tokenBalanceInfoMap"] as?  [String: Any],
            let array = Array(map.values) as? [[String: Any]] {
            onroadInfoArray = array
        }

        let onroadInfos = onroadInfoArray.map({ OnroadInfo(JSON: $0) })
        let ret = onroadInfos.compactMap { $0 }
        return ret
    }
}
