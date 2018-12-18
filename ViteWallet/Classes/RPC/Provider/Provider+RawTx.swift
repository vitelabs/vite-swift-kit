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
                                    amount: BigInt,
                                    data: String?) -> Promise<Void> {

        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<Void> in
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
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: send))).promise.map { _ in Void() }
        }
    }

    public func sendRawTxWithPow(account: Wallet.Account,
                                 toAddress: Address,
                                 tokenId: String,
                                 amount: BigInt,
                                 data: String?,
                                 difficulty: BigInt,
                                 cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {

        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [weak self] (latestAccountBlock, fittestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, nonce: String)> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, $0) }
            }.then { [weak self] (latestAccountBlock, fittestSnapshotHash, nonce: String) -> Promise<Void> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let send = AccountBlock.makeSendAccountBlock(secretKey: account.secretKey,
                                                             publicKey: account.publicKey,
                                                             address: account.address,
                                                             latest: latestAccountBlock,
                                                             snapshotHash: fittestSnapshotHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: data,
                                                             nonce: nonce,
                                                             difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: send))).promise.map { _ in Void() }
        }
    }
}
