//
//  GetFittestSnapshotHashRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetFittestSnapshotHashRequest: JSONRPCKit.Request {
    public typealias Response = String

    let address: String
    let sendAccountBlockHash: String?

    public var method: String {
        return "ledger_getFittestSnapshotHash"
    }

    public var parameters: Any? {
        if let hash = sendAccountBlockHash {
            return [address, hash]
        } else {
            return [address]
        }
    }

    public init(address: String, sendAccountBlockHash: String? = nil) {
        self.address = address
        self.sendAccountBlockHash = sendAccountBlockHash
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
