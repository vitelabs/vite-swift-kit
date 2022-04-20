//
//  DexVxUnlockInfo.swift
//  ViteWallet
//
//  Created by vite on 2022/4/21.
//

import Foundation
import ObjectMapper

public struct DexVxUnlockInfo : Mappable {
    public fileprivate(set) var unlockingAmount: Amount = Amount(0)
    public fileprivate(set) var count: Int64 = 0
    public fileprivate(set) var list: [Info] = []

    init() { }

    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        unlockingAmount <- (map["unlockingAmount"], JSONTransformer.balance)
        count <- map["count"]
        list <- map["unlocks"]
    }
    
    public struct Info: Mappable {
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
