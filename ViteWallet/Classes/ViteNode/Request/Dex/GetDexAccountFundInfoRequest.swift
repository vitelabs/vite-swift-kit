//
//  GetDexAccountFundInfoRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/8/31.
//

import Foundation
import JSONRPCKit

public struct GetDexAccountFundInfoRequest: JSONRPCKit.Request {
    public typealias Response = [ViteTokenId: DexAccountFundInfo]

    let address: ViteAddress
    let tokenId: ViteTokenId?

    public var method: String {
        return "dex_getAccountBalanceInfo"
    }

    public var parameters: Any? {
        if let tokenId = tokenId {
            return [address, tokenId]
        } else {
            return [address, nil]
        }
    }

    public init(address: ViteAddress, tokenId: ViteTokenId?) {
        self.address = address
        self.tokenId = tokenId
    }

    public func response(from resultObject: Any) throws -> Response {

        if let _ = resultObject as? NSNull {
            return [:]
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var infoArray = [[String: Any]]()
        if let array = Array(response.values) as? [[String: Any]] {
            infoArray = array
        }

        let balanceInfos = infoArray.map({ DexAccountFundInfo(JSON: $0) })
        let ret = balanceInfos.compactMap { $0 }
        return ret.reduce([ViteTokenId: DexAccountFundInfo]()) { (ret, info) -> Response in
            var ret = ret
            ret[info.token.id] = info
            return ret
        }
    }
}
