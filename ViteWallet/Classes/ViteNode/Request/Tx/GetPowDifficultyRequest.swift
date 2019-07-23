//
//  GetPowDifficultyRequest.swift
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

public struct GetPowDifficultyRequest: JSONRPCKit.Request {
    public typealias Response = AccountBlockQuota

    public let context: GetPowDifficultyContext

    public var method: String {
        return "tx_calcPoWDifficulty"
    }

    public var parameters: Any? {
        return [context.toJSON()]
    }

    public init(accountAddress: ViteAddress,
                prevHash: String,
                type: AccountBlock.BlockType,
                toAddress: ViteAddress?,
                data: Data?,
                usePledgeQuota: Bool) {

        self.context = GetPowDifficultyContext(accountAddress: accountAddress,
                                               prevHash: prevHash,
                                               type: type,
                                               toAddress: toAddress,
                                               data: data,
                                               usePledgeQuota: usePledgeQuota)
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any],
            let difficultyString = response["difficulty"] as? String,
            let quota = response["quota"] as? UInt64
//            , let ut = response["ut"] as? String
        {

            let difficulty: BigInt?
            if !difficultyString.isEmpty {
                guard let bi = BigInt(difficultyString) else {
                    throw ViteError.JSONTypeError
                }
                difficulty = bi
            } else {
                difficulty = nil
            }
            let ut = "xxx"
            return AccountBlockQuota(quota: quota, ut: ut, difficulty: difficulty)
        } else {
            throw ViteError.JSONTypeError
        }
    }
}

extension GetPowDifficultyRequest {
    public struct GetPowDifficultyContext: Mappable {

        fileprivate(set) var accountAddress: ViteAddress?
        fileprivate(set) var prevHash: String?
        fileprivate(set) var type: AccountBlock.BlockType?
        fileprivate(set) var toAddress: ViteAddress?
        fileprivate(set) var data: Data?
        fileprivate(set) var usePledgeQuota: Bool?

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            accountAddress <- map["selfAddr"]
            prevHash <- map["prevHash"]
            type <- map["blockType"]
            toAddress <- map["toAddr"]
            data <- (map["data"], JSONTransformer.dataToBase64)
            usePledgeQuota <- map["usePledgeQuota"]
        }

        public init(accountAddress: ViteAddress,
                    prevHash: String,
                    type: AccountBlock.BlockType,
                    toAddress: ViteAddress?,
                    data: Data?,
                    usePledgeQuota: Bool) {

            self.accountAddress = accountAddress
            self.prevHash = prevHash
            self.type = type
            self.toAddress = toAddress
            self.data = data
            self.usePledgeQuota = usePledgeQuota
        }
    }
}
