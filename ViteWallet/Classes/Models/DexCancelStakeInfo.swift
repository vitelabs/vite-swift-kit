//
//  DexCancelStakeInfo.swift
//  ViteWallet
//
//  Created by vite on 2022/4/14.
//

import Foundation
import ObjectMapper

public struct DexCancelStakeInfo : Mappable {
    public fileprivate(set) var totalCancellingAmount: Amount = Amount(0)
    public fileprivate(set) var totalCancelCount: Int64 = 0
    public fileprivate(set) var list: [Cancel] = []

    init() { }

    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        totalCancellingAmount <- (map["cancellingAmount"], JSONTransformer.balance)
        totalCancelCount <- map["count"]
        list <- map["cancels"]
    }
    
    public struct Cancel: Mappable {
        public fileprivate(set) var amount: Amount = Amount(0)
        public fileprivate(set) var expirationTime = Date(timeIntervalSince1970: 0)
        public fileprivate(set) var expirationPeriod: UInt64 = 0
        
        public init?(map: Map) { }

        public mutating func mapping(map: Map) {

            amount <- (map["amount"], JSONTransformer.balance)
            expirationTime <- (map["expirationTime"], JSONTransformer.timestamp)
            expirationPeriod <- map["expirationPeriod"]
        }
    }
}
