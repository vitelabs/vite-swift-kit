//
//  GetTestTokenRequest.swift
//  Vite
//
//  Created by Stone on 2018/11/15.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit
import BigInt

public struct GetTestTokenRequest: JSONRPCKit.Request {

    public typealias Response = Balance

    let address: String

    public var method: String {
        return "testapi_getTestToken"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: String) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let bigInt = BigInt(response) {
            return Balance(value: bigInt)
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
