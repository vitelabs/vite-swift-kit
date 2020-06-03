//
//  DexMiningInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import ObjectMapper
import BigInt

public struct DexMiningInfo: Mappable {

    public fileprivate(set) var historyMinedSum = Amount(0)
    public fileprivate(set) var total = Amount(0)
    public fileprivate(set) var feeMineTotal = Amount(0)
    public fileprivate(set) var stakingMine = Amount(0)
    public fileprivate(set) var makerMine = Amount(0)

    public fileprivate(set) var feeMineVite = Amount(0)
    public fileprivate(set) var feeMineEth = Amount(0)
    public fileprivate(set) var feeMineBtc = Amount(0)
    public fileprivate(set) var feeMineUsdt = Amount(0)

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {

        historyMinedSum <- (map["historyMinedSum"], JSONTransformer.balance)
        total <- (map["total"], JSONTransformer.balance)
        feeMineTotal <- (map["feeMineTotal"], JSONTransformer.balance)
        stakingMine <- (map["stakingMine"], JSONTransformer.balance)
        makerMine <- (map["makerMine"], JSONTransformer.balance)

        feeMineVite <- (map["feeMineDetail.1"], JSONTransformer.balance)
        feeMineEth <- (map["feeMineDetail.2"], JSONTransformer.balance)
        feeMineBtc <- (map["feeMineDetail.3"], JSONTransformer.balance)
        feeMineUsdt <- (map["feeMineDetail.4"], JSONTransformer.balance)
    }
}
