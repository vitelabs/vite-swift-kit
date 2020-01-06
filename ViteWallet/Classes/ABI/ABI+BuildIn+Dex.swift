//
//  ABI+BuildIn+Dex.swift
//  ViteWallet
//
//  Created by Stone on 2020/1/6.
//

import BigInt

extension ABI.BuildIn {

    public static func getDexDepositData() -> Data {
        return getData(type: .dexDeposit, values: [])
    }

    public static func getDexWithdrawData(tokenId: ViteTokenId, amount: Amount) -> Data {
        return getData(type: .dexWithdraw, values: [tokenId, amount.description])
    }

    public static func getDexBindInviterData(code: String) -> Data {
        return getData(type: .dexBindInviteCode, values: [code])
    }
}
