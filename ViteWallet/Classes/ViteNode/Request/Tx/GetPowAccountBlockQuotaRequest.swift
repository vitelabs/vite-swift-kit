//
//  GetPowAccountBlockQuotaRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt
import JSONRPCKit
import Vite_HDWalletKit
import ObjectMapper

public struct GetPowAccountBlockQuotaRequest: JSONRPCKit.Request {
    public typealias Response = AccountBlockQuota

    let context: Context

    public var method: String {
        return "tx_calcQuotaRequired"
    }

    public var parameters: Any? {
        return [context.toJSON()]
    }

    public init(accountAddress: ViteAddress,
                type: AccountBlock.BlockType,
                toAddress: ViteAddress?,
                data: Data?) {
        self.context = Context(accountAddress: accountAddress, type: type, toAddress: toAddress, data: data)
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any] {
            if let ret = AccountBlockQuota(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else {
            throw ViteError.JSONTypeError
        }
    }
}

extension GetPowAccountBlockQuotaRequest {
    public struct Context: Mappable {

        fileprivate(set) var accountAddress: ViteAddress?
        fileprivate(set) var type: AccountBlock.BlockType?
        fileprivate(set) var toAddress: ViteAddress?
        fileprivate(set) var data: Data?

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            accountAddress <- map["selfAddr"]
            type <- map["blockType"]
            toAddress <- map["toAddr"]
            data <- (map["data"], JSONTransformer.dataToBase64)
        }

        public init(accountAddress: ViteAddress,
                    type: AccountBlock.BlockType,
                    toAddress: ViteAddress?,
                    data: Data?) {

            self.accountAddress = accountAddress
            self.type = type
            self.toAddress = toAddress
            self.data = data
        }
    }
}
