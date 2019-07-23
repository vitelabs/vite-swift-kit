//
//  AccountBlockQuota.swift
//  ViteWallet
//
//  Created by Stone on 2019/7/23.
//

import BigInt

public struct AccountBlockQuota {
    public let quota: UInt64
    public let ut: String
    public let difficulty: BigInt?

    public var isNeedToCalcPoW: Bool {
        return difficulty != nil
    }
}
