//
//  GetDexCurrentMiningStakingAmountByAddressRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/8/31.
//

import Foundation
import JSONRPCKit

public struct GetDexCurrentMiningStakingAmountByAddressRequest: JSONRPCKit.Request {
    public typealias Response = Amount

    let address: ViteAddress

    public var method: String {
        return "dex_getCurrentMiningStakingAmountByAddress"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: String],
            let ret = try? response.values.reduce(Amount(0)) { (ret, string) -> Amount in
                var sum = ret
                guard let amount = Amount(string) else {
                    throw ViteError.JSONTypeError
                }
                return sum + amount
            } {
            return ret
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
