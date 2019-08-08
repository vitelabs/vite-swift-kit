//
//  Quota.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/4.
//

import Foundation
import ObjectMapper

public struct Quota: Mappable {

    public fileprivate(set) var quotaPerSnapshotBlock: UInt64 = 0
    public fileprivate(set) var currentQuota: UInt64 = 0

    public fileprivate(set) var utpe: Double = 0
    public fileprivate(set) var currentUt: Double = 0
    public fileprivate(set) var pledgeAmount = Amount(0)

    public init?(map: Map) {

    }

    public init() {}

    public mutating func mapping(map: Map) {
        quotaPerSnapshotBlock <- (map["quotaPerSnapshotBlock"], JSONTransformer.uint64)
        currentQuota <- (map["current"], JSONTransformer.uint64)
        utpe <- (map["utpe"], JSONTransformer.stringToDouble)
        currentUt <- (map["currentUt"], JSONTransformer.stringToDouble)
        pledgeAmount <- (map["pledgeAmount"], JSONTransformer.bigint)
    }
}

extension Double {
    public func utToString() -> String {
        var text = String(format:"%.4f", self)
        if text.contains(".") {
            text = text.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            if text.hasSuffix(".") {
                text = String(text.dropLast())
            }
        }
        if text.isEmpty {
            text = "0"
        }
        return text
    }
}
