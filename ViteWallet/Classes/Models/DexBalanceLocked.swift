//
//  DexBalanceLocked.swift
//  ViteBusiness
//
//  Created by Stone on 2020/8/31.
//

import Foundation
import ObjectMapper
import BigInt
import ViteWallet

public struct DexBalanceLocked: Mappable {

    public fileprivate(set) var vxLocked = Amount()
    public fileprivate(set) var vxUnlocking = Amount()

    public fileprivate(set) var viteStakeForVip = Amount()
    public fileprivate(set) var viteStakeForMining = Amount()
    public fileprivate(set) var viteCancellingStakeForMining = Amount()

    public init?(map: Map) {

    }

    public init(vxLocked: Amount = 0, vxUnlocking: Amount = 0, viteStakeForVip: Amount = 0, viteStakeForMining: Amount = 0, viteCancellingStakeForMining: Amount = 0) {
        self.vxLocked = vxLocked
        self.vxUnlocking = vxUnlocking
        self.viteStakeForVip = viteStakeForVip
        self.viteStakeForMining = viteStakeForMining
        self.viteCancellingStakeForMining = viteCancellingStakeForMining
    }

    public mutating func mapping(map: Map) {
        vxLocked <- (map["vxLocked"], JSONTransformer.balance)
        vxUnlocking <- (map["vxUnlocking"], JSONTransformer.balance)
        viteStakeForVip <- (map["viteStakeForVip"], JSONTransformer.balance)
        viteStakeForMining <- (map["viteStakeForMining"], JSONTransformer.balance)
        viteCancellingStakeForMining <- (map["viteCancellingStakeForMining"], JSONTransformer.balance)
    }
}


