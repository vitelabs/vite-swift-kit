//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public final class Provider {
    public static let `default` = Provider(server: RPCServer.shared)

    public fileprivate(set) var server: RPCServer
    public init(server: RPCServer) {
        self.server = server
    }

    public func update(server: RPCServer) {
        self.server = server
    }
}

// MARK: Send Raw Tx
extension Provider {
    fileprivate func sendRawTxWithoutPow(account: Wallet.Account,
                             toAddress: Address,
                             tokenId: String,
                             amount: BigInt,
                             data: String?) -> Promise<Void> {

        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [unowned self] (latestAccountBlock, fittestSnapshotHash) -> Promise<Void> in
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

    fileprivate func sendRawTxWithPow(account: Wallet.Account,
                          toAddress: Address,
                          tokenId: String,
                          amount: BigInt,
                          data: String?,
                          difficulty: BigInt,
                          cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {

        let batch = BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description),
                                          GetFittestSnapshotHashRequest(address: account.address.description))
        return RPCRequest(for: server, batch: batch).promise
            .then { [unowned self] (latestAccountBlock, fittestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String, nonce: String)> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, fittestSnapshotHash, $0) }
            }.then { [unowned self] (latestAccountBlock, fittestSnapshotHash, nonce: String) -> Promise<Void> in
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

// MARK: Ledger
extension Provider {

    public func getSnapshotChainHeight() -> Promise<UInt64> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetSnapshotChainHeightRequest())).promise
    }

    public func getToken(for id: String) -> Promise<Token> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTokenInfoRequest(tokenId: id))).promise
    }

    public func getTestToken(address: Address) -> Promise<Balance> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTestTokenRequest(address: address.description))).promise
    }

    public func getBalanceInfos(address: Address) -> Promise<[BalanceInfo]> {
        let batch = BatchFactory().create(GetBalanceInfosRequest(address: address.description),
                                          GetOnroadInfosRequest(address: address.description))
        return RPCRequest(for: server, batch: batch).promise
            .map { BalanceInfo.mergeBalanceInfos($0, onroadInfos: $1) }
    }

    public func getTransactions(address: Address, hash: String?, count: Int) -> Promise<(transactions: [Transaction], nextHash: String?)> {
        return RPCRequest(for: server, batch: BatchFactory().create(GetTransactionsRequest(address: address.description, hash: hash, count: count))).promise
    }
}

// MARK: Recover Addresses
extension Provider {
    public func recoverAddresses(_ addresses: [Address]) -> Promise<Int> {
        guard addresses.count == 10 else { fatalError() }

        func makePromise(startIndex: Int) -> Promise<Int?> {
            let start = startIndex
            let mid = start + 1
            let end = mid + 1

            return RPCRequest(for: server, batch: BatchFactory()
                .create(request1: GetBalanceInfosRequest(address: addresses[start].description),
                        GetOnroadInfosRequest(address: addresses[start].description),
                        GetBalanceInfosRequest(address: addresses[mid].description),
                        GetOnroadInfosRequest(address: addresses[mid].description),
                        GetBalanceInfosRequest(address: addresses[end].description),
                        GetOnroadInfosRequest(address: addresses[end].description))).promise
                .map { (bStart, uStart, bMid, uMid, bEnd, uEnd) -> Int? in
                    let s = BalanceInfo.mergeBalanceInfos(bStart, onroadInfos: uStart)
                    let m = BalanceInfo.mergeBalanceInfos(bMid, onroadInfos: uMid)
                    let e = BalanceInfo.mergeBalanceInfos(bEnd, onroadInfos: uEnd)
                    if !e.isEmpty {
                        return end
                    } else if !m.isEmpty {
                        return mid
                    } else if !s.isEmpty {
                        return start
                    } else {
                        return nil
                    }
            }
        }

        let p123 = makePromise(startIndex: 1)
        let p456 = makePromise(startIndex: 4)
        let p789 = makePromise(startIndex: 7)

        return when(fulfilled: p123, p456, p789)
            .map { (p1, p4, p7) -> Int in
                let count = (p7 ?? p4 ?? p1 ?? 0) + 1
                return count
            }
    }
}

// MARK: Send & Receive Transaction
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

    public func receiveTransactionWithoutPow(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<Void> {

        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description))).promise
            .then { [unowned self] (latestAccountBlock) -> Promise<(latestAccountBlock: AccountBlock?, fittestSnapshotHash: String)> in
                let request = GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, $0) }
            }.then { [unowned self] (latestAccountBlock, fittestSnapshotHash) -> Promise<Void> in
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   unconfirmed: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   snapshotHash: fittestSnapshotHash,
                                                                   nonce: nil,
                                                                   difficulty: nil)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in Void() }
        }
    }

    public func receiveTransactionWithPow(account: Wallet.Account,
                                          onroadBlock: AccountBlock,
                                          difficulty: BigInt,
                                          cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {

        return RPCRequest(for: server, batch: BatchFactory().create(GetLatestAccountBlockRequest(address: account.address.description))).promise
            .then { [unowned self] (latestAccountBlock) -> Promise<(latestAccountBlock: AccountBlock?, nonce: String)> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetPowNonceRequest(address: account.address, preHash: latestAccountBlock?.hash, difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, $0) }
            }.then { [unowned self] (latestAccountBlock, nonce) -> Promise<(latestAccountBlock: AccountBlock?, nonce: String, fittestSnapshotHash: String)> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let request = GetFittestSnapshotHashRequest(address: account.address.description, sendAccountBlockHash: onroadBlock.hash)
                return RPCRequest(for: self.server, batch: BatchFactory().create(request)).promise.map { (latestAccountBlock, nonce, $0) }
            }.then { [unowned self] (latestAccountBlock, nonce, fittestSnapshotHash) -> Promise<Void> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   unconfirmed: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   snapshotHash: fittestSnapshotHash,
                                                                   nonce: nonce,
                                                                   difficulty: difficulty)
                return RPCRequest(for: self.server, batch: BatchFactory().create(SendRawTxRequest(accountBlock: receive))).promise.map { _ in Void() }
        }
    }

    public func receiveLatestTransactionIfHasWithoutPow(account: Wallet.Account) -> Promise<Void> {
        let request = GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] onroadBlocks -> Promise<Void> in
                guard let onroadBlock = onroadBlocks.first else { return Promise { $0.fulfill(Void()) } }
                return self.receiveTransactionWithoutPow(account: account, onroadBlock: onroadBlock)
        }
    }

    public func receiveLatestTransactionIfHasWithPow(account: Wallet.Account,
                                                     difficulty: BigInt,
                                                     cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {
        let request = GetOnroadBlocksRequest(address: account.address.description, index: 0, count: 1)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] onroadBlocks -> Promise<Void> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                guard let onroadBlock = onroadBlocks.first else { return Promise { $0.fulfill(Void()) } }
                return self.receiveTransactionWithPow(account: account, onroadBlock: onroadBlock, difficulty: difficulty, cancel: cancel)
        }
    }
}

// MARK: Pledge
extension Provider {

    public func getPledges(address: Address, index: Int, count: Int) -> Promise<[Pledge]> {
        let request = GetPledgesRequest(address: address.description, index: index, count: count)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
    }

    public func pledgeWithoutPow(account: Wallet.Account,
                                 beneficialAddress: Address,
                                 amount: BigInt) -> Promise<Void> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] data -> Promise<Void> in
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: amount,
                                                data: data)
        }
    }

    public func pledgeWithPow(account: Wallet.Account,
                                 beneficialAddress: Address,
                                 amount: BigInt,
                                 difficulty: BigInt,
                                 cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] data -> Promise<Void> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithPow(account: account,
                                             toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                             tokenId: ViteWalletConst.viteToken.id,
                                             amount: amount,
                                             data: data,
                                             difficulty: difficulty,
                                             cancel: cancel)
        }
    }
}

// MARK: Vote
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
            .then { [unowned self] data -> Promise<Void> in
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.vote.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: 0,
                                                data: data)
        }
    }

    public func voteWithPow(account: Wallet.Account,
                            gid: String,
                            name: String,
                            difficulty: BigInt,
                            cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {
        let request = GetVoteDataRequest(gid: gid, name: name)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] data -> Promise<Void> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithPow(account: account,
                                             toAddress: ViteWalletConst.ContractAddress.vote.address,
                                             tokenId: ViteWalletConst.viteToken.id,
                                             amount: 0,
                                             data: data,
                                             difficulty: difficulty,
                                             cancel: cancel)
        }
    }

    public func cancelVoteWithoutPow(account: Wallet.Account,
                                     gid: String,
                                     name: String) -> Promise<Void> {
        let request = GetCancelVoteDataRequest(gid: gid)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] data -> Promise<Void> in
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.vote.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: 0,
                                                data: data)
        }
    }

    public func cancelVoteWithPow(account: Wallet.Account,
                                  gid: String,
                                  name: String,
                                  difficulty: BigInt,
                                  cancel: @escaping () -> (Bool) = { return false } ) -> Promise<Void> {
        let request = GetCancelVoteDataRequest(gid: gid)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [unowned self] data -> Promise<Void> in
                guard cancel() == false else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithPow(account: account,
                                             toAddress: ViteWalletConst.ContractAddress.vote.address,
                                             tokenId: ViteWalletConst.viteToken.id,
                                             amount: 0,
                                             data: data,
                                             difficulty: difficulty,
                                             cancel: cancel)
        }
    }
}
