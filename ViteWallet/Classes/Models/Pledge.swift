//
//  Pledge.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

public struct Pledge: Mappable {

    public fileprivate(set) var stakeAddress: String = ""
    public fileprivate(set) var amount = Amount(0)
    public fileprivate(set) var withdrawHeight: UInt64 = 0
    public fileprivate(set) var beneficialAddress = ""
    public fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    public fileprivate(set) var agent = false
    public fileprivate(set) var agentAddress = ""
    public fileprivate(set) var bid: UInt8 = 0
    public fileprivate(set) var id: String?
           
    public init?(map: Map) { }

    public mutating func mapping(map: Map) {

        stakeAddress <- map["stakeAddress"]
        amount <- (map["stakeAmount"], JSONTransformer.balance)
        withdrawHeight <- (map["expirationHeight"], JSONTransformer.uint64)
        beneficialAddress <- map["beneficiary"]
        timestamp <- (map["withdrawTime"], JSONTransformer.timestamp)
        agent <- map["isDelegated"]
        agentAddress <- map["delegateAddress"]
        bid <- map["bid"]
        id <- map["id"]
    }
}
