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

    public init?(map: Map) {

    }

    public init(token: Token, available: Amount = 0, locked: Amount = 0) {
        self.token = token
        self.available = available
        self.locked = locked
    }

    public var total: Amount {
        return available + locked
    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        available <- (map["available"], JSONTransformer.balance)
        locked <- (map["locked"], JSONTransformer.balance)
    }


}


