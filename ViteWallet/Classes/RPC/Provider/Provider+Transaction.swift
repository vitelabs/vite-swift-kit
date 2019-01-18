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

    public func sendTransactionWithoutPow(account: Wallet.Account,
                                          toAddress: Address,
                                          tokenId: String,
                                          amount: Balance,
                                          note: String?) -> Promise<AccountBlock> {

        return sendRawTxWithoutPow(account: account,
                                   toAddress: toAddress,
                                   tokenId: tokenId,
                                   amount: amount,
                                   data:note?.bytes.toBase64())
    }

    public func getPowForSendTransaction(account: Wallet.Account,
                                         toAddress: Address,
                                         tokenId: String,
                                         amount: Balance,
                                         note: String?) -> Promise<SendBlockContext> {
        return getPowForSendRawTx(account: account, toAddress: toAddress, tokenId: tokenId, amount: amount, data: note?.bytes.toBase64())
    }

    public func receiveTransactionWithoutPow(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<AccountBlock> {

        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                                                    GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash))).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<AccountBlock> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   onroadBlock: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   snapshotHash: fittestSnapshotHash,
                                                                   nonce: nil,
                                                                   difficulty: nil)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in onroadBlock }
        }
    }

    public func getPowForReceiveTransaction(account: Wallet.Account,
                                            onroadBlock: AccountBlock) -> Promise<ReceiveBlockContext> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                                                    GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash))).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, difficulty: BigInt)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let request = GetPowDifficultyRequest(accountAddress: account.address,
                                                      prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                                      snapshotHash: fittestSnapshotHash,
                                                      type: .receive,
                                                      toAddress: nil,
                                                      data: nil,
                                                      usePledgeQuota: false)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, $0) }
            }
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash, difficulty) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, difficulty: BigInt, nonce: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, difficulty, $0) }
            }
            .map { (latestAccountBlock, fittestSnapshotHash, difficulty, nonce) -> ReceiveBlockContext in
                ReceiveBlockContext(account: account,
                                    onroadBlock: onroadBlock,
                                    latest: latestAccountBlock,
                                    snapshotHash: fittestSnapshotHash,
                                    nonce: nonce,
                                    difficulty: difficulty)
        }
    }

    public func receiveLatestTransactionIfHasWithoutPow(account: Wallet.Account) -> Promise<AccountBlock?> {
        let request = GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] onroadBlocks -> Promise<AccountBlock?> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard let onroadBlock = onroadBlocks.first else { return Promise.value(nil) }
                return self.receiveTransactionWithoutPow(account: account, onroadBlock: onroadBlock).map { block -> AccountBlock? in block }
        }
    }

    public func receiveLatestTransactionIfHasWithPow(account: Wallet.Account) -> Promise<AccountBlock?> {
        let request = GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] onroadBlocks -> Promise<ReceiveBlockContext?> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard let onroadBlock = onroadBlocks.first else { return Promise.value(nil) }
                return self.getPowForReceiveTransaction(account: account, onroadBlock: onroadBlock).map { context -> ReceiveBlockContext? in context }
            }
            .then { [weak self] context -> Promise<AccountBlock?> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard let context = context else { return Promise.value(nil) }
                return self.sendRawTxWithContext(context).map { block -> AccountBlock? in block }
        }
    }
}
