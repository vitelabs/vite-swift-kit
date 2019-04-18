//
//  GetCancelPledgeDataRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetCancelPledgeDataRequest: JSONRPCKit.Request {
    public typealias Response = Data

    let beneficialAddress: ViteAddress
    let amount: Amount

    public var method: String {
        return "pledge_getCancelPledgeData"
    }

    public var parameters: Any? {
        return [beneficialAddress, amount.description]
    }

    public init(beneficialAddress: ViteAddress, amount: Amount) {
        self.beneficialAddress = beneficialAddress
        self.amount = amount
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String,
            let ret = Data(base64Encoded: response) {
            return ret
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
