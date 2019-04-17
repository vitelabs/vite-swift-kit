//
//  GetPledgeDetailRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetPledgeDetailRequest: JSONRPCKit.Request {
    public typealias Response = PledgeDetail

    let address: ViteAddress
    let index: Int
    let count: Int

    public var method: String {
        return "pledge_getPledgeList"
    }

    public var parameters: Any? {
        return [address, index, count]
    }

    public init(address: ViteAddress, index: Int, count: Int) {
        self.address = address
        self.index = index
        self.count = count
    }

    public func response(from resultObject: Any) throws -> Response {
        guard let response = resultObject as? [String: Any],
            let ret = PledgeDetail(JSON: response)else {
                throw ViteError.JSONTypeError
        }
        return ret
    }
}
