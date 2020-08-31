//
//  DexAccountFundInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/8/31.
//

import Foundation
import ObjectMapper
import BigInt

public struct DexAccountFundInfo: Mappable {

    public fileprivate(set) var token = Token()
    public fileprivate(set) var available = Amount()
    public fileprivate(set) var locked = Amount()

    public fileprivate(set) var vxLocked = Amount()         // Only valid for VX
    public fileprivate(set) var vxUnlocking = Amount()      // Only valid for VX
    public fileprivate(set) var viteCancellingStake = Amount()  // Only valid for VITE



    public init?(map: Map) {

    }

    public init(token: Token, available: Amount = 0, locked: Amount = 0, vxLocked: Amount = 0, vxUnlocking: Amount = 0, viteCancellingStake: Amount = 0) {
        self.token = token
        self.available = available
        self.locked = locked

        self.vxLocked = vxLocked
        self.vxUnlocking = vxUnlocking
        self.viteCancellingStake = viteCancellingStake
    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        available <- (map["available"], JSONTransformer.balance)
        locked <- (map["locked"], JSONTransformer.balance)

        vxLocked <- (map["vxLocked"], JSONTransformer.balance)
        vxUnlocking <- (map["vxUnlocking"], JSONTransformer.balance)
        viteCancellingStake <- (map["cancellingStake"], JSONTransformer.balance)
    }
}
