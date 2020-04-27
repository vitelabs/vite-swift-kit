//
//  DexMarketInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/4/23.
//

import Foundation
import ObjectMapper

public struct DexMarketInfo: Mappable {

    public fileprivate(set) var marketSymbol: String = ""
    public fileprivate(set) var takerBrokerFeeRate: Int64 = 0
    public fileprivate(set) var makerBrokerFeeRate: Int64 = 0

    public init() { }

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        marketSymbol <- map["marketSymbol"]
        takerBrokerFeeRate <- map["takerOperatorFeeRate"]
        makerBrokerFeeRate <- map["makerOperatorFeeRate"]
    }
}
