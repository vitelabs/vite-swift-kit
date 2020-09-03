//
//  BalanceInfo.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

public struct BalanceInfo: Mappable {

    public fileprivate(set) var token = Token()
    public fileprivate(set) var balance = Amount()
    public fileprivate(set) var unconfirmedBalance = Amount()
    public fileprivate(set) var unconfirmedCount: UInt64 = 0

    public fileprivate(set) var viteStakeForPledge = Amount()       // Only valid for VITE
    public fileprivate(set) var viteStakeForSBP = Amount()          // Only valid for VITE
    public fileprivate(set) var viteStakeForFullNode = Amount()     // Only valid for VITE

    public init?(map: Map) {

    }

    public init(token: Token, balance: Amount = 0, unconfirmedBalance: Amount = 0, unconfirmedCount: UInt64 = 0) {
        self.token = token
        self.balance = balance
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        balance <- (map["totalAmount"], JSONTransformer.balance)

        viteStakeForPledge <- (map["viteStakeForPledge"], JSONTransformer.balance)
        viteStakeForSBP <- (map["viteStakeForSBP"], JSONTransformer.balance)
        viteStakeForFullNode <- (map["viteStakeForFullNode"], JSONTransformer.balance)
    }

    mutating func fill(unconfirmedBalance: Amount, unconfirmedCount: UInt64) {
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }

    public var total: Amount {
        if token.id == ViteWalletConst.viteToken.id {
            return balance + viteStake
        } else {
            return balance
        }
    }

    public var viteStake: Amount {
        if token.id == ViteWalletConst.viteToken.id {
            return viteStakeForPledge + viteStakeForSBP + viteStakeForFullNode
        } else {
            return Amount(0)
        }
    }

    public mutating func mergeLockedInfoIfNeeded(info: WalletBalanceLocked) {
        if token.id == ViteWalletConst.viteToken.id {
            viteStakeForPledge = info.viteStakeForPledge
            viteStakeForSBP = info.viteStakeForSBP
            viteStakeForFullNode = info.viteStakeForFullNode
        }
    }
}

extension BalanceInfo: Equatable {
    public static func == (lhs: BalanceInfo, rhs: BalanceInfo) -> Bool {
        return lhs.token.id == rhs.token.id
    }
}

extension BalanceInfo {
    
    public static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo], onroadInfos: [OnroadInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for onroadInfo in onroadInfos {
            if let index = (infos as Array).index(where: { ($0 as! BalanceInfo).token.id == onroadInfo.token.id }) {
                var info = infos[index] as! BalanceInfo
                info.fill(unconfirmedBalance: onroadInfo.unconfirmedBalance, unconfirmedCount: onroadInfo.unconfirmedCount)
                ret.add(info)
                infos.removeObject(at: index)
            } else {
                let info = BalanceInfo(token: onroadInfo.token, balance: Amount(0), unconfirmedBalance: onroadInfo.unconfirmedBalance, unconfirmedCount: onroadInfo.unconfirmedCount)
                ret.add(info)
            }
        }
        ret.addObjects(from: infos as! [Any])
        return ret as! [BalanceInfo]
    }
}
