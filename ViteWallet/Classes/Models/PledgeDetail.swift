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
    public fileprivate(set) var totalPledgeAmount = Balance()
    public fileprivate(set) var totalCount: UInt64 = 0

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        list <- map["pledgeInfoList"]
        totalPledgeAmount <- (map["totalPledgeAmount"], JSONTransformer.balance)
        totalCount <- map["totalCount"]
    }
}
