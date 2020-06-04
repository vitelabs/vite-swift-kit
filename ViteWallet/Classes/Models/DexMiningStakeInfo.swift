//
//  DexMiningStakeInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/4.
//

import Foundation
import ObjectMapper

public struct DexMiningStakeInfo : Mappable {
    public fileprivate(set) var totalStakeAmount: Amount = Amount(0)
    public fileprivate(set) var totalStakeCount: Int64 = 0
    public fileprivate(set) var list: [Pledge] = []

    init() { }

    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        totalStakeAmount <- (map["totalStakeAmount"], JSONTransformer.balance)
        totalStakeCount <- map["totalStakeCount"]
        list <- map["stakeList"]
    }
}
