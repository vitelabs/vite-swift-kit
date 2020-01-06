//
//  ABI+BuildIn+Vote.swift
//  ViteWallet
//
//  Created by Stone on 2020/1/6.
//

import BigInt

extension ABI.BuildIn {

    public static func getVoteForSBPData(name: String) -> Data {
        return getData(type: .voteForSBP, values: [name])
    }

    public static func getCancelSBPVotingData() -> Data {
        return getData(type: .cancelSBPVoting, values: [])
    }
}
