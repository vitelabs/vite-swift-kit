//
//  GetPledgeBeneficialAmountRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit
import BigInt

public struct GetPledgeBeneficialAmountRequest: JSONRPCKit.Request {
    public typealias Response = Balance

    let address: String

    public var method: String {
        return "pledge_getPledgeBeneficialAmount"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: String) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        guard let response = resultObject as? String,
            let bignit = BigInt(response) else {
                throw ViteError.JSONTypeError
        }

        return Balance(value: bignit)
    }
}
