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
                                          amount: BigInt,
                                          note: String?) -> Promise<Void> {

        return sendRawTxWithoutPow(account: account,
                                   toAddress: toAddress,
                                   tokenId: tokenId,
                                   amount: amount,
                                   data:note?.bytes.toBase64())
    }

    public func sendTransactionWithPow(account: Wallet.Account,
                                       toAddress: Address,
                                       tokenId: String,
                                       amount: BigInt,
                                       note: String?,
                                       difficulty: BigInt,
                                       cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {

        return sendRawTxWithPow(account: account,
                                toAddress: toAddress,
                                tokenId: tokenId,
                                amount: amount,
                                data:note?.bytes.toBase64(),
                                difficulty: difficulty,
                                cancel: cancel)
    }

    public func receiveTransactionWithoutPow(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<AccountBlock> {

        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description))).promise
            .then { [weak self] (latestAccountBlock) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let request = GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, $0) }
            }.then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<AccountBlock> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   unconfirmed: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   snapshotHash: fittestSnapshotHash,
                                                                   nonce: nil,
                                                                   difficulty: nil)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in onroadBlock }
        }
    }

    public func receiveTransactionWithPow(account: Wallet.Account,
                                          onroadBlock: AccountBlock,
                                          difficulty: BigInt,
                                          cancel: @escaping () -> (Bool) = { return false } ) -> Promise<AccountBlock> {

        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description))).promise
            .then { [weak self] (latestAccountBlock) -> Promise<(latestAccountBlock: AccountBlock?, nonce: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, $0) }
            }.then { [weak self] (latestAccountBlock, nonce) -> Promise<(latestAccountBlock: AccountBlock?, nonce: String, fittestSnapshotHash: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, nonce, $0) }
            }.then { [weak self] (latestAccountBlock, nonce, fittestSnapshotHash) -> Promise<AccountBlock> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   unconfirmed: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   snapshotHash: fittestSnapshotHash,
                                                                   nonce: nonce,
                                                                   difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in onroadBlock }
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

    public func receiveLatestTransactionIfHasWithPow(account: Wallet.Account,
                                                     difficulty: BigInt,
                                                     cancel: @escaping () -> (Bool) = { return false } ) -> Promise<AccountBlock?> {
        let request = GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] onroadBlocks -> Promise<AccountBlock?> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                guard let onroadBlock = onroadBlocks.first else { return Promise.value(nil) }
                return self.receiveTransactionWithPow(account: account, onroadBlock: onroadBlock, difficulty: difficulty, cancel: cancel).map { block -> AccountBlock? in block }
        }
    }
}
