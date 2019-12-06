//
//  DefiAccountInfoRequest.swift
//  Action
//
//  Created by haoshenyang on 2019/12/6.
//

import Foundation
import JSONRPCKit

public struct DefiAccountInfoRequest: JSONRPCKit.Request {
    public typealias Response = DefiAccountInfo?

    let address: String
    let tokenId: String

    public var method: String {
        return "defi_getAccountInfo"
    }

    public var parameters: Any? {
        return [address, tokenId]
    }

    public init(address: String,tokenId:String) {
        self.address = address
        self.tokenId = tokenId
    }

    public func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return nil
        } else if let response = (resultObject as? [String: Any])?[self.tokenId] as? [String: Any]{
            if let ret = DefiAccountInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
