//
//  PlaceOrderInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/7/24.
//

import Foundation
import ObjectMapper
import BigInt

public struct PlaceOrderInfo: Mappable {

    public fileprivate(set) var available = Amount(0)
    public fileprivate(set) var minTradeAmount = Amount(0)

    public fileprivate(set) var feeRate: Int64 = 0
    public fileprivate(set) var side = false

    public fileprivate(set) var isVIP = false
    public fileprivate(set) var isSVIP = false
    public fileprivate(set) var isInvited = false

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {

        available <- (map["available"], JSONTransformer.balance)
        minTradeAmount <- (map["minTradeAmount"], JSONTransformer.balance)

        feeRate <- map["feeRate"]
        side <- map["beneficiary"]

        isVIP <- map["isVIP"]
        isSVIP <- map["isSVIP"]
        isInvited <- map["isInvited"]

    }
}
