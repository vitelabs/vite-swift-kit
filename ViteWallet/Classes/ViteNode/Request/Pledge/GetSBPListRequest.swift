//
//  GetSBPListRequest.swift
//  ViteWallet
//
//  Created by Stone on 2020/9/2.
//

import Foundation
import JSONRPCKit

public struct GetSBPListRequest: JSONRPCKit.Request {
    public typealias Response = [SBPInfo]

    let address: ViteAddress

    public var method: String {
        return "contract_getSBPList"
    }

    public var parameters: Any? {
        return [address]
    }

    public init(address: ViteAddress) {
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        if let _ = resultObject as? NSNull {
            return []
        }

        guard let response = resultObject as? [[String: Any]] else {
            throw ViteError.JSONTypeError
        }

        let infos = response.map({ SBPInfo(JSON: $0) })
        let ret = infos.compactMap { $0 }
        return ret
    }
}
