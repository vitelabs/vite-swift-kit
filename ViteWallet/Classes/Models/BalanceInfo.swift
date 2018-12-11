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
    public fileprivate(set) var balance = Balance()
    public fileprivate(set) var unconfirmedBalance = Balance()
    public fileprivate(set) var unconfirmedCount: UInt64 = 0

    public init?(map: Map) {

    }

    init(token: Token, balance: Balance, unconfirmedBalance: Balance, unconfirmedCount: UInt64) {
        self.token = token
        self.balance = balance
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }

    public mutating func mapping(map: Map) {
        token <- map["tokenInfo"]
        balance <- (map["totalAmount"], JSONTransformer.balance)
    }

    mutating func fill(unconfirmedBalance: Balance, unconfirmedCount: UInt64) {
        self.unconfirmedBalance = unconfirmedBalance
        self.unconfirmedCount = unconfirmedCount
    }
}

extension BalanceInfo: Equatable {
    public static func == (lhs: BalanceInfo, rhs: BalanceInfo) -> Bool {
        return lhs.token.id == rhs.token.id
    }
}

extension BalanceInfo {

    static func mergeBalanceInfos(_ balanceInfos: [BalanceInfo], onroadInfos: [OnroadInfo]) -> [BalanceInfo] {
        let infos = NSMutableArray(array: balanceInfos)
        let ret = NSMutableArray()

        for onroadInfo in onroadInfos {
            if let index = (infos as Array).index(where: { ($0 as! BalanceInfo).token.id == onroadInfo.token.id }) {
                var info = infos[index] as! BalanceInfo
                info.fill(unconfirmedBalance: onroadInfo.unconfirmedBalance, unconfirmedCount: onroadInfo.unconfirmedCount)
                ret.add(info)
                infos.removeObject(at: index)
            } else {
                let info = BalanceInfo(token: onroadInfo.token, balance: Balance(value: BigInt(0)), unconfirmedBalance: onroadInfo.unconfirmedBalance, unconfirmedCount: onroadInfo.unconfirmedCount)
                ret.add(info)
            }
        }
        ret.addObjects(from: infos as! [Any])
        return ret as! [BalanceInfo]
    }
}
