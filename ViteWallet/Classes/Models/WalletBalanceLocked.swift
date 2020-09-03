//
//  WalletBalanceLocked.swift
//  Pods
//
//  Created by Stone on 2020/9/2.
//

import Foundation
import ObjectMapper
import BigInt
import ViteWallet

public struct WalletBalanceLocked: Mappable {

    public fileprivate(set) var viteStakeForPledge = Amount()
    public fileprivate(set) var viteStakeForSBP = Amount()
    public fileprivate(set) var viteStakeForFullNode = Amount()

    public init?(map: Map) {

    }

    public init(viteStakeForPledge: Amount = 0, viteStakeForSBP: Amount = 0, viteStakeForFullNode: Amount = 0) {
        self.viteStakeForPledge = viteStakeForPledge
        self.viteStakeForSBP = viteStakeForSBP
        self.viteStakeForFullNode = viteStakeForFullNode
    }

    public mutating func mapping(map: Map) {
        viteStakeForPledge <- (map["viteStakeForPledge"], JSONTransformer.balance)
        viteStakeForSBP <- (map["viteStakeForSBP"], JSONTransformer.balance)
        viteStakeForFullNode <- (map["viteStakeForFullNode"], JSONTransformer.balance)
    }
}
