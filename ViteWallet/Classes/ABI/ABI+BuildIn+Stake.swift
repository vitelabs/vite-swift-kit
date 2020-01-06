//
//  ABI+BuildIn+Stake.swift
//  ViteWallet
//
//  Created by Stone on 2020/1/6.
//

import BigInt

extension ABI.BuildIn {

    public static func getStakeForQuota(beneficialAddress: ViteAddress) -> Data {
        return getData(type: .stakeForQuota, values: [beneficialAddress])
    }

    public static func getCancelPledgeData(beneficialAddress: ViteAddress, amount: Amount) -> Data {
        return getData(type: .old_cancelStake, values: [beneficialAddress, amount.description])
    }

    public static func getCancelQuotaStakingData(id: String) -> Data {
        return getData(type: .cancelQuotaStaking, values: [id])
    }
}
