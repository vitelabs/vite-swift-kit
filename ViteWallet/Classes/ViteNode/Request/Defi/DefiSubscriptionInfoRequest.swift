//
//  DefiSubscriptionInfoRequest.swift
//  Action
//
//  Created by haoshenyang on 2019/12/6.
//

import Foundation
import JSONRPCKit

public struct DefiSubscriptionInfoRequest: JSONRPCKit.Request {
    public typealias Response = DefiSubscriptionInfo?

    let id: Int

    public var method: String {
        return "defi_getSubscriptionInfo"
    }

    public var parameters: Any? {
        return [id]
    }

    public init(id: Int) {
        self.id = id
    }

    public func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return nil
        } else if let response = resultObject as? [String: Any] {
            if let ret = DefiSubscriptionInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
