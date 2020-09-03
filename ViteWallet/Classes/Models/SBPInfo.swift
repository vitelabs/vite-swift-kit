//
//  SBPInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/9/2.
//

import Foundation
import ObjectMapper
import BigInt

public struct SBPInfo: Mappable {

    public fileprivate(set) var name: String = ""
    public fileprivate(set) var blockProducingAddress: ViteAddress = ""
    public fileprivate(set) var rewardWithdrawAddress: ViteAddress = ""
    public fileprivate(set) var stakeAddress: ViteAddress = ""
    public fileprivate(set) var stakeAmount = Amount(0)
    public fileprivate(set) var expirationHeight: UInt64 = 0
    public fileprivate(set) var expirationTime = Date(timeIntervalSince1970: 0)
    public fileprivate(set) var revokeTime = Date(timeIntervalSince1970: 0)

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {

        name <- map["name"]
        blockProducingAddress <- map["blockProducingAddress"]
        rewardWithdrawAddress <- map["rewardWithdrawAddress"]
        stakeAddress <- map["stakeAddress"]
        stakeAmount <- (map["stakeAmount"], JSONTransformer.balance)
        expirationHeight <- (map["expirationHeight"], JSONTransformer.uint64)
        expirationTime <- (map["expirationTime"], JSONTransformer.timestamp)
        revokeTime <- (map["revokeTime"], JSONTransformer.timestamp)
    }
}
