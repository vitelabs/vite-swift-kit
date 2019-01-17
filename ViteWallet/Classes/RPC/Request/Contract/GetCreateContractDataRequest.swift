//
//  GetPledgeQuotaRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

//public struct GetPledgeQuotaRequest: JSONRPCKit.Request {
//    public typealias Response = (UInt64, UInt64)
//
//    let address: String
//
//    public var method: String {
//        return "pledge_getPledgeQuota"
//    }
//
//    public var parameters: Any? {
//        return [address]
//    }
//
//    public init(address: String) {
//        self.address = address
//    }
//
//    public func response(from resultObject: Any) throws -> Response {
//
//        guard let response = resultObject as? [String: Any] else {
//            throw ViteError.JSONTypeError
//        }
//
//        if let quotaString = response["quota"] as? String,
//            let maxTxCountString = response["txNum"] as? String,
//            let quota = UInt64(quotaString),
//             let maxTxCount = UInt64(maxTxCountString) {
//            return (quota, maxTxCount)
//        } else {
//            throw ViteError.JSONTypeError
//        }
//    }
//}
