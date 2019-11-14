//
//  GetDexInviteCodeBindingRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetDexInviteCodeBindingRequest: JSONRPCKit.Request {
    public typealias Response = Int64?

    let address: ViteAddress

    public var method: String {
        return "dex_getInviteCodeBinding"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {

        guard let response = resultObject as? Int64 else {
            throw ViteError.JSONTypeError
        }

        if response > 0 {
            return response
        } else {
            return nil
        }
    }
}
