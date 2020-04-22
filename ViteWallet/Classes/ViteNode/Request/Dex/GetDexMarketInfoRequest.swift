//
//  GetDexMarketInfoRequest.swift
//  Vite
//
//  Created by Stone on 2020/4/23.
//

import Foundation
import JSONRPCKit

public struct GetDexMarketInfoRequest: JSONRPCKit.Request {
    public typealias Response = DexMarketInfo

    let tradeTokenId: ViteTokenId
    let quoteTokenId: ViteTokenId

    public var method: String {
        return "dex_getMarketInfo"
    }

    public var parameters: Any? {
        return [tradeTokenId, quoteTokenId]
    }

    public init(tradeTokenId: ViteTokenId, quoteTokenId: ViteTokenId) {
        self.tradeTokenId = tradeTokenId
        self.quoteTokenId = quoteTokenId
    }

    public func response(from resultObject: Any) throws -> Response {
         if let response = resultObject as? [String: Any] {
            if let ret = DexMarketInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
