//
//  DexBalanceInfo.swift
//  ViteWallet
//
//  Created by Stone on 2019/9/9.
//

import Foundation
import ObjectMapper
import BigInt

public struct DexBalanceInfo: Mappable {

    public fileprivate(set) var token = Token()
    public fileprivate(set) var available = Amount()
    public fileprivate(set) var locked = Amount()

    public fileprivate(set) var vxLocked = Amount()                     // Only valid for VX
    public fileprivate(set) var vxUnlocking = Amount()                  // Only valid for VX

    public fileprivate(set) var viteStakeForVip = Amount()              // Only valid for VITE
    public fileprivate(set) var viteStakeForMining = Amount()           // Only valid for VITE
    public fileprivate(set) var viteCancellingStakeForMining = Amount() // Only valid for VITE

    public init?(map: Map) {

    }

    public init(token: Token, available: Amount = 0, locked: Amount = 0, vxLocked: Amount = 0, vxUnlocking: Amount = 0, viteStakeForVip: Amount = 0, viteStakeForMining: Amount = 0, viteCancellingStakeForMining: Amount = 0) {
        self.token = token
        self.available = available
        self.locked = locked

        self.vxLocked = vxLocked
        self.vxUnlocking = vxUnlocking
        self.viteStakeForVip = viteStakeForVip
        self.viteStakeForMining = viteStakeForMining
        self.viteCancellingStakeForMining = viteCancellingStakeForMining
    }

    public var total: Amount {
        if token.id == ViteWalletConst.viteToken.id {
            return available + locked + viteStakeForVip + viteCancellingStakeForMining + viteCancellingStakeForMining
        } else if token.id == "tti_564954455820434f494e69b5" {
            return available + locked + vxLocked + vxUnlocking
        } else {
            return available + locked
        }
    }

    public mutating func mergeLockedInfoIfNeeded(info: DexBalanceLocked) {
        if token.id == ViteWalletConst.viteToken.id {
            viteStakeForVip = info.viteStakeForVip
            viteStakeForMining = info.viteStakeForMining
            viteCancellingStakeForMining = info.viteCancellingStakeForMining
        } else if token.id == "tti_564954455820434f494e69b5" {
            vxLocked = info.vxLocked
            vxUnlocking = info.vxUnlocking
        }
    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        available <- (map["available"], JSONTransformer.balance)
        locked <- (map["locked"], JSONTransformer.balance)

        vxLocked <- (map["vxLocked"], JSONTransformer.balance)
        vxUnlocking <- (map["vxUnlocking"], JSONTransformer.balance)
        viteStakeForVip <- (map["viteStakeForVip"], JSONTransformer.balance)
        viteStakeForMining <- (map["viteStakeForMining"], JSONTransformer.balance)
        viteCancellingStakeForMining <- (map["viteCancellingStakeForMining"], JSONTransformer.balance)
    }
}


