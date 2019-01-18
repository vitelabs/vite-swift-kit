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
    public func sendRawTxWithoutPow(account: Wallet.Account,
                                    toAddress: Address,
                                    tokenId: String,
                                    amount: Balance,
                                    data: String?) -> Promise<AccountBlock> {

        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<AccountBlock> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let send = AccountBlock.makeSendAccountBlock(secretKey: account.secretKey,
                                                             publicKey: account.publicKey,
                                                             address: account.address,
                                                             latest: latestAccountBlock,
                                                             snapshotHash: fittestSnapshotHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: send))).promise.map { _ in send }
        }
    }

    public func getPowForSendRawTx(account: Wallet.Account,
                                   toAddress: Address,
                                   tokenId: String,
                                   amount: Balance,
                                   data: String?) -> Promise<SendBlockContext> {
        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, difficulty: BigInt)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let request = GetPowDifficultyRequest(accountAddress: account.address,
                                                      prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                                      snapshotHash: fittestSnapshotHash,
                                                      type: .send,
                                                      toAddress: toAddress,
                                                      data: data,
                                                      usePledgeQuota: false)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, $0) }
            }
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash, difficulty) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, difficulty: BigInt, nonce: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, difficulty, $0) }
            }.map { (latestAccountBlock, fittestSnapshotHash, difficulty, nonce) -> SendBlockContext in
                SendBlockContext(account: account,
                                 latest: latestAccountBlock,
                                 snapshotHash: fittestSnapshotHash,
                                 toAddress: toAddress,
                                 tokenId: tokenId,
                                 amount: amount,
                                 data: data,
                                 nonce: nonce,
                                 difficulty: difficulty)
            }
    }

    public func sendRawTxWithContext(_ context: SendBlockContext) -> Promise<AccountBlock> {
        let send = AccountBlock.makeSendAccountBlock(secretKey: context.account.secretKey,
                                                     publicKey: context.account.publicKey,
                                                     address: context.account.address,
                                                     latest: context.latest,
                                                     snapshotHash: context.snapshotHash,
                                                     toAddress: context.toAddress,
                                                     tokenId: context.tokenId,
                                                     amount: context.amount,
                                                     data: context.data,
                                                     nonce: context.nonce,
                                                     difficulty: context.difficulty)
        return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: send))).promise.map { _ in send }
    }

    public func sendRawTxWithContext(_ context: ReceiveBlockContext) -> Promise<AccountBlock> {
        let receive = AccountBlock.makeReceiveAccountBlock(secretKey: context.account.secretKey,
                                                           publicKey: context.account.publicKey,
                                                           address: context.account.address,
                                                           onroadBlock: context.onroadBlock,
                                                           latest: context.latest,
                                                           snapshotHash: context.snapshotHash,
                                                           nonce: context.nonce,
                                                           difficulty: context.difficulty)
        return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in receive }
    }

    public struct SendBlockContext {
        let account: Wallet.Account
        let latest: AccountBlock?
        let snapshotHash: String
        let toAddress: Address
        let tokenId: String
        let amount: Balance
        let data: String?
        let nonce: String?
        let difficulty: BigInt?
    }

    public struct ReceiveBlockContext {
        let account: Wallet.Account
        let onroadBlock: AccountBlock
        let latest: AccountBlock?
        let snapshotHash: String
        let nonce: String?
        let difficulty: BigInt?
    }
}
