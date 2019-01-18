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
    public typealias Response = BigInt

    public let context: GetPowDifficultyContext

    public var method: String {
        return "tx_calcPoWDifficulty"
    }

    public var parameters: Any? {
        return [context.toJSON()]
    }

    public init(accountAddress: Address,
                prevHash: String,
                snapshotHash: String,
                type: AccountBlock.BlockType,
                toAddress: Address?,
                data: String?,
                usePledgeQuota: Bool) {

        self.context = GetPowDifficultyContext(accountAddress: accountAddress,
                                               prevHash: prevHash,
                                               snapshotHash: snapshotHash,
                                               type: type,
                                               toAddress: toAddress,
                                               data: data,
                                               usePledgeQuota: usePledgeQuota)
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let difficulty = BigInt(response) {
            return difficulty
        } else {
            throw ViteError.JSONTypeError
        }
    }
}

extension GetPowDifficultyRequest {
    public struct GetPowDifficultyContext: Mappable {

        fileprivate(set) var accountAddress: Address?
        fileprivate(set) var prevHash: String?
        fileprivate(set) var snapshotHash: String?
        fileprivate(set) var type: AccountBlock.BlockType?
        fileprivate(set) var toAddress: Address?
        fileprivate(set) var data: String?
        fileprivate(set) var usePledgeQuota: Bool?

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            accountAddress <- (map["selfAddr"], JSONTransformer.address)
            prevHash <- map["prevHash"]
            snapshotHash <- map["snapshotHash"]
            type <- map["blockType"]
            toAddress <- (map["toAddr"], JSONTransformer.address)
            data <- map["data"]
            usePledgeQuota <- map["usePledgeQuota"]
        }

        public init(accountAddress: Address,
                    prevHash: String,
                    snapshotHash: String,
                    type: AccountBlock.BlockType,
                    toAddress: Address?,
                    data: String?,
                    usePledgeQuota: Bool) {

            self.accountAddress = accountAddress
            self.prevHash = prevHash
            self.snapshotHash = snapshotHash
            self.type = type
            self.toAddress = toAddress
            self.data = data
            self.usePledgeQuota = usePledgeQuota
        }
    }
}
