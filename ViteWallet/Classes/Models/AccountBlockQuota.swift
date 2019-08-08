//
//  AccountBlockQuota.swift
//  ViteWallet
//
//  Created by Stone on 2019/7/23.
//

import BigInt
import ObjectMapper

public struct AccountBlockQuota: Mappable {
    public fileprivate(set) var quotaRequired: UInt64 = 0
    public fileprivate(set) var utRequired: Double = 0
    public fileprivate(set) var difficulty: BigInt?

    public fileprivate(set) var isCongestion: Bool = false
    public fileprivate(set) var qc: BigInt = 0

    public var isNeedToCalcPoW: Bool {
        return difficulty != nil
    }

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        quotaRequired <- (map["quotaRequired"], JSONTransformer.uint64)
        utRequired <- (map["utRequired"], JSONTransformer.stringToDouble)
        difficulty <- (map["difficulty"], TransformOf<BigInt, String>(fromJSON: { (string) -> BigInt? in
            guard let string = string, !string.isEmpty, let bigInt = BigInt(string) else { return nil }
            return bigInt
        }, toJSON: { (bigint) -> String? in
            guard let bigint = bigint else { return nil }
            return String(bigint)
        }))

        isCongestion <- map["isCongestion"]
        qc <- (map["qc"], JSONTransformer.bigint)
    }
}
