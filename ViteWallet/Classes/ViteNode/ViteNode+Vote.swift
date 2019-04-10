//
//  ViteNode+Vote.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.vote {
    public struct info {}
    public struct perform {}
    public struct cancel {}
}

public extension ViteNode.vote.info {
    static func getCandidateList(gid: String) -> Promise<[Candidate]> {
        return GetCandidateListRequest(gid: gid).defaultProviderPromise
    }

    static func getVoteInfo(gid: String, address: Address) -> Promise<VoteInfo?> {
        return GetVoteInfoRequest(gid: gid, address: address.description).defaultProviderPromise
    }
}

public extension ViteNode.vote.perform {
    static func withoutPow(account: Wallet.Account, gid: String, name: String) -> Promise<AccountBlock> {
        return GetVoteDataRequest(gid: gid, name: name).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.consensus.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: Balance(value: BigInt(0)),
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account, gid: String, name: String) -> Promise<SendBlockContext> {
        return GetVoteDataRequest(gid: gid, name: name).defaultProviderPromise
            .then { data -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account,
                                                  toAddress: ViteWalletConst.ContractAddress.consensus.address,
                                                  tokenId: ViteWalletConst.viteToken.id,
                                                  amount: Balance(value: BigInt(0)),
                                                  data: data)
        }
    }
}

public extension ViteNode.vote.cancel {
    static func withoutPow(account: Wallet.Account, gid: String) -> Promise<AccountBlock> {
        return GetCancelVoteDataRequest(gid: gid).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.consensus.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: Balance(value: BigInt(0)),
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account, gid: String) -> Promise<SendBlockContext> {
        return GetCancelVoteDataRequest(gid: gid).defaultProviderPromise
            .then { data -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account,
                                                  toAddress: ViteWalletConst.ContractAddress.consensus.address,
                                                  tokenId: ViteWalletConst.viteToken.id,
                                                  amount: Balance(value: BigInt(0)),
                                                  data: data)
        }
    }
}
