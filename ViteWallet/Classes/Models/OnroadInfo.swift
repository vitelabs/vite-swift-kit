//
//  OnroadInfo.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

public struct OnroadInfo: Mappable {

    public fileprivate(set) var token = Token()
    public fileprivate(set) var unconfirmedBalance = Amount()
    public fileprivate(set) var unconfirmedCount: UInt64 = 0
    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        unconfirmedBalance <- (map["totalAmount"], JSONTransformer.balance)
        unconfirmedCount <- (map["number"], JSONTransformer.uint64)
    }
}
