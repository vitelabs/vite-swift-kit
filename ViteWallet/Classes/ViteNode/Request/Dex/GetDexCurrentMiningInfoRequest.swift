//
//  GetDexCurrentMiningInfoRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import JSONRPCKit

public struct GetDexCurrentMiningInfoRequest: JSONRPCKit.Request {
    public typealias Response = DexMiningInfo

    public var method: String {
        return "dex_getCurrentMiningInfo"
    }

    public var parameters: Any? {
        return []
    }

    public init() { }

    public func response(from resultObject: Any) throws -> Response {
         if let response = resultObject as? [String: Any] {
            if let ret = DexMiningInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
