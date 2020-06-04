//
//  GetDexMiningTradingFeeInfoRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import JSONRPCKit

public struct GetDexMiningTradingFeeInfoRequest: JSONRPCKit.Request {
    public typealias Response = DexTradingMiningFeeInfo

    public var method: String {
        return "dex_getCurrentFeesValidForMining"
    }

    public var parameters: Any? {
        return []
    }

    public init() { }

    public func response(from resultObject: Any) throws -> Response {
         if let response = resultObject as? [String: Any] {
            if let ret = DexTradingMiningFeeInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
