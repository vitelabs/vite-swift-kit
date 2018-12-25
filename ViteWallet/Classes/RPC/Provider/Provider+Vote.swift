//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit
import PromiseKit
import BigInt

extension Provider {
    public func getCandidateList(gid: String) -> Promise<[Candidate]> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetCandidateListRequest(gid: gid))).promise
    }

    public func getVoteInfo(gid: String, address: Address) -> Promise<VoteInfo?> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetVoteInfoRequest(gid: gid, address: address.description))).promise
    }

    public func voteWithoutPow(account: Wallet.Account,
                               gid: String,
                               name: String) -> Promise<Void> {
        let request = GetVoteDataRequest(gid: gid, name: name)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<Void> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.vote.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: Balance(value: BigInt(0)),
                                                data: data)
        }
    }

    public func getPowForVote(account: Wallet.Account,
                              gid: String,
                              name: String,
                              difficulty: BigInt) -> Promise<SendBlockContext> {
        let request = GetVoteDataRequest(gid: gid, name: name)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<SendBlockContext> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.getPowForSendRawTx(account: account,
                                               toAddress: ViteWalletConst.ContractAddress.vote.address,
                                               tokenId: ViteWalletConst.viteToken.id,
                                               amount: Balance(value: BigInt(0)),
                                               data: data,
                                               difficulty: difficulty)
        }
    }

    public func cancelVoteWithoutPow(account: Wallet.Account, gid: String) -> Promise<Void> {
        let request = GetCancelVoteDataRequest(gid: gid)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<Void> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.vote.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: Balance(value: BigInt(0)),
                                                data: data)
        }
    }

    public func getPowForCancelVote(account: Wallet.Account,
                                    gid: String,
                                    difficulty: BigInt) -> Promise<SendBlockContext> {
        let request = GetCancelVoteDataRequest(gid: gid)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<SendBlockContext> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.getPowForSendRawTx(account: account,
                                               toAddress: ViteWalletConst.ContractAddress.vote.address,
                                               tokenId: ViteWalletConst.viteToken.id,
                                               amount: Balance(value: BigInt(0)),
                                               data: data,
                                               difficulty: difficulty)
        }
    }
}
