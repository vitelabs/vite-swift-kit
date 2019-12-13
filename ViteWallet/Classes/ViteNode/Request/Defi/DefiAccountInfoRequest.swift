//
//  DefiAccountInfoRequest.swift
//  Action
//
//  Created by haoshenyang on 2019/12/6.
//

import Foundation
import JSONRPCKit

public struct DefiAccountInfoRequest: JSONRPCKit.Request {
    public typealias Response = [DefiBalanceInfo]

    let address: String
    let tokenId: String?

    public var method: String {
        return "defi_getAccountInfo"
    }

    public var parameters: Any? {
        if let tokenId = tokenId {
            return [address, tokenId]
        } else {
            return [address, nil]
        }
    }

    public init(address: String, tokenId:String?) {
        self.address = address
        self.tokenId = tokenId
    }

    public func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var balanceInfoArray = [[String: Any]]()
        if let array = Array(response.values) as? [[String: Any]] {
            balanceInfoArray = array
        }

        let balanceInfos = balanceInfoArray.map({ DefiBalanceInfo(JSON: $0) })
        let ret = balanceInfos.compactMap { $0 }

        return ret
    }
}
