//
//  GetLatestAccountBlockRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetLatestAccountBlockRequest: JSONRPCKit.Request {
    public typealias Response = AccountBlock?

    let address: String

    public var method: String {
        return "ledger_getLatestBlock"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: String) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return nil
        } else if let response = resultObject as? [String: Any] {
            if let ret = AccountBlock(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
