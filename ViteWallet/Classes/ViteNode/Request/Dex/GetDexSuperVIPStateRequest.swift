//
//  GetDexSuperVIPStateRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetDexSuperVIPStateRequest: JSONRPCKit.Request {
    public typealias Response = Bool

    let address: ViteAddress

    public var method: String {
        return "dex_hasStakedForSVIP"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {

        guard let response = resultObject as? Bool else {
            throw ViteError.JSONTypeError
        }

        return response
    }
}
