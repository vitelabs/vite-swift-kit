//
//  GetOnroadBlocksRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetOnroadBlocksRequest: JSONRPCKit.Request {
    public typealias Response = [AccountBlock]

    let address: ViteAddress
    let index: Int
    let count: Int

    public var method: String {
        return "onroad_getOnroadBlocksByAddress"
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
        var response = [[String: Any]]()
        if let object = resultObject as? [[String: Any]] {
            response = object
        }

        let block = response.map({ AccountBlock(JSON: $0) })
        let ret = block.compactMap { $0 }
        return ret
    }
}
