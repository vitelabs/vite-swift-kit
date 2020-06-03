//
//  GetDexFeesByAddressRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import JSONRPCKit

public struct GetDexFeesByAddressRequest: JSONRPCKit.Request {
    public typealias Response = DexAddressFeeInfo

    let address: ViteAddress

    public var method: String {
        return "dex_getAllFeesOfAddress"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
         if let _ = resultObject as? NSNull {
             return DexAddressFeeInfo()
         } else if let response = resultObject as? [String: Any] {
            if let ret = DexAddressFeeInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
