//
//  GetAccountBlocksByHashInTokenRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetAccountBlocksByHashInTokenRequest: JSONRPCKit.Request {
    public typealias Response = (accountBlocks: [AccountBlock], nextHash: String?)

    let address: String
    let hash: String?
    let tokenId: String
    let count: Int

    public var method: String {
        return "ledger_getBlocksByHashInToken"
    }

    public var parameters: Any? {
        if let hash = hash {
            return [address, hash, tokenId, count + 1]
        } else {
            return [address, nil, tokenId, count + 1]
        }
    }

    public init(address: String, tokenId: String, hash: String? = nil, count: Int) {
        self.address = address
        self.tokenId = tokenId
        self.hash = hash
        self.count = count
    }

    public func response(from resultObject: Any) throws -> Response {
        var response = [[String: Any]]()
        if let object = resultObject as? [[String: Any]] {
            response = object
        }

        let transactions = response.map({ AccountBlock(JSON: $0) })
        let ret = transactions.compactMap { $0 }

        if ret.count > count {
            return (Array(ret.dropLast()), ret.last?.hash)
        } else {
            return (ret, nil)
        }
    }
}
