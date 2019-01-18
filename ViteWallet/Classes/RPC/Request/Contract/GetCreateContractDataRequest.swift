//
//  GetCreateContractDataRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetCreateContractDataRequest: JSONRPCKit.Request {
    public typealias Response = String

    let gid: String
    let codeHexString: String
    let abi: String
    let contractParameters: [String]

    public var method: String {
        return "contract_getCreateContractData"
    }

    public var parameters: Any? {
        return [gid, codeHexString, abi, contractParameters]
    }

    public init(gid: String, codeHexString: String, abi: String, contractParameters: [String]) {
        self.gid = gid
        self.codeHexString = codeHexString
        self.abi = abi
        self.contractParameters = contractParameters
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
