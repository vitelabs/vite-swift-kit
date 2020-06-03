//
//  DexTradingMiningFeeInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import ObjectMapper
import BigInt

public struct DexTradingMiningFeeInfo: Mappable {

    public fileprivate(set) var vite = Amount(0)
    public fileprivate(set) var eth = Amount(0)
    public fileprivate(set) var btc = Amount(0)
    public fileprivate(set) var usdt = Amount(0)

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {

        vite <- (map["1"], JSONTransformer.balance)
        eth <- (map["2"], JSONTransformer.balance)
        btc <- (map["3"], JSONTransformer.balance)
        usdt <- (map["4"], JSONTransformer.balance)
    }
}
