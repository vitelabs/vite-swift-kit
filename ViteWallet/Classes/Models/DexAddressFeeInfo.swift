//
//  DexAddressFeeInfo.swift
//  ViteWallet
//
//  Created by Stone on 2020/6/2.
//

import Foundation
import ObjectMapper
import BigInt

public struct DexAddressFeeInfo: Mappable {

    fileprivate var array: [Fee] = []

    public init?(map: Map) { }

    init() {}

    public mutating func mapping(map: Map) {
        array <- map["fees.userFees"]
    }

    public var vite: Fee? {
        for fee in array where fee.quoteTokenType == 1 {
            return fee
        }
        return nil
    }

    public var eth: Fee? {
        for fee in array where fee.quoteTokenType == 2 {
            return fee
        }
        return nil
    }

    public var btc: Fee? {
        for fee in array where fee.quoteTokenType == 3 {
            return fee
        }
        return nil
    }

    public var usdt: Fee? {
        for fee in array where fee.quoteTokenType == 4 {
            return fee
        }
        return nil
    }


    public struct Fee: Mappable {
        public fileprivate(set) var quoteTokenType: Int = 0
        public fileprivate(set) var base = Amount(0)
        public fileprivate(set) var inviteBonus = Amount(0)

        public init?(map: Map) { }

        public mutating func mapping(map: Map) {
            quoteTokenType <- map["quoteTokenType"]
            base <- (map["baseAmount"], JSONTransformer.balance)
            inviteBonus <- (map["inviteBonusAmount"], JSONTransformer.balance)
        }
    }
}
