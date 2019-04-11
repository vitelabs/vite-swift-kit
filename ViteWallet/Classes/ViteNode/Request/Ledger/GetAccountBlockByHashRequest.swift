//
//  GetAccountBlockByHashRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetAccountBlockByHashRequest: JSONRPCKit.Request {
    public typealias Response = AccountBlock?

    let hash: String

    public var method: String {
        return "ledger_getBlockByHash"
    }

    public var parameters: Any? {
        return [hash]
    }

    public init(hash: String) {
        self.hash = hash
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
