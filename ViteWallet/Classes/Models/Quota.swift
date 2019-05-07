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
    public fileprivate(set) var current: UInt64 = 0
    public fileprivate(set) var utps: UInt64 = 0

    public init?(map: Map) {

    }

    public init() {}

    public mutating func mapping(map: Map) {
        quotaPerSnapshotBlock <- (map["quotaPerSnapshotBlock"], JSONTransformer.uint64)
        current <- (map["current"], JSONTransformer.uint64)
        utps <- (map["utps"], JSONTransformer.uint64)
    }
}
