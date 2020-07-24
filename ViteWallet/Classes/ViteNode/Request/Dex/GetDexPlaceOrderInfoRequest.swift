//
//  GetDexPlaceOrderInfoRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetDexPlaceOrderInfoRequest: JSONRPCKit.Request {
    public typealias Response = PlaceOrderInfo

    let address: ViteAddress
    let tradeTokenId: ViteTokenId
    let quoteTokenId: ViteTokenId
    let side: Bool // false: buy  true: sell

    public var method: String {
        return "dex_getPlaceOrderInfo"
    }

    public var parameters: Any? {
        return [address, tradeTokenId, quoteTokenId, side]
    }

    public init(address: ViteAddress, tradeTokenId: ViteTokenId, quoteTokenId: ViteTokenId, side: Bool) {
        self.address = address
        self.tradeTokenId = tradeTokenId
        self.quoteTokenId = quoteTokenId
        self.side = side
    }

    public func response(from resultObject: Any) throws -> Response {
        guard let response = resultObject as? [String: Any],
            let ret = PlaceOrderInfo(JSON: response)else {
                throw ViteError.JSONTypeError
        }
        return ret
    }
}
