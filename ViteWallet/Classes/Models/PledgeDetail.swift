//
//  PledgeDetail.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

public struct PledgeDetail: Mappable {

    public fileprivate(set) var list: [Pledge] = [Pledge]()
    public fileprivate(set) var totalPledgeAmount = Amount()
    public fileprivate(set) var totalCount: UInt64 = 0

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        list <- map["stakeList"]
        totalPledgeAmount <- (map["totalStakeAmount"], JSONTransformer.balance)
        totalCount <- map["totalStakeCount"]
    }
}
