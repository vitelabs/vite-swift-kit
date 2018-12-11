//
//  GetPledgeDataRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetPledgeDataRequest: JSONRPCKit.Request {
    public typealias Response = String

    let beneficialAddress: String

    public var method: String {
        return "pledge_getPledgeData"
    }

    public var parameters: Any? {
        return [beneficialAddress]
    }

    public init(beneficialAddress: String) {
        self.beneficialAddress = beneficialAddress
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
