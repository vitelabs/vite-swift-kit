//
//  GetSnapshotChainHeightRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetSnapshotChainHeightRequest: JSONRPCKit.Request {
    public typealias Response = UInt64

    public init() {

    }

    public var method: String {
        return "ledger_getSnapshotChainHeight"
    }

    public var parameters: Any? {
        return nil
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let height = UInt64(response) {
            return height
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
