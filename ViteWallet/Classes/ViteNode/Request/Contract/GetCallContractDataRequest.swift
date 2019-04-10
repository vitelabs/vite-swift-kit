//
//  GetCallContractDataRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/24.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetCallContractDataRequest: JSONRPCKit.Request {
    public typealias Response = Data

    let abi: String
    let functionName: String
    let contractParameters: [String]

    public var method: String {
        return "contract_getCallContractData"
    }

    public var parameters: Any? {
        return [abi, functionName, contractParameters]
    }

    public init(abi: String, functionName: String, contractParameters: [String]) {
        self.abi = abi
        self.functionName = functionName
        self.contractParameters = contractParameters
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String,
            let ret = Data(base64Encoded: response) {
            return ret
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
