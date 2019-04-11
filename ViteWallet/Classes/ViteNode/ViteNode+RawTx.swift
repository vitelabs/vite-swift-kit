//
//  ViteNode+RawTx.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.rawTx {
    public struct send {}
    public struct receive {}
}

public extension ViteNode.rawTx.send {
    static func withoutPow(account: Wallet.Account,
                           toAddress: Address,
                           tokenId: String,
                           amount: Balance,
                           data: Data?) -> Promise<AccountBlock> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<AccountBlock> in
                let send = AccountBlock.makeSendAccountBlock(secretKey: account.secretKey,
                                                             publicKey: account.publicKey,
                                                             address: account.address,
                                                             latest: latestAccountBlock,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return ViteNode.tx.sendRawTx(accountBlock: send)
        }
    }

    static func getPow(account: Wallet.Account,
                       toAddress: Address,
                       tokenId: String,
                       amount: Balance,
                       data: Data?) -> Promise<SendBlockContext> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<(latestAccountBlock: AccountBlock?, difficulty: BigInt)> in
                ViteNode.tx.getPowDifficulty(accountAddress: account.address,
                                             prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                             type: .send,
                                             toAddress: toAddress,
                                             data: data,
                                             usePledgeQuota: false).map { (latestAccountBlock, $0) }
            }
            .then { (latestAccountBlock, difficulty) -> Promise<(latestAccountBlock: AccountBlock?, difficulty: BigInt, nonce: String)> in
                ViteNode.pow.getNonce(address: account.address,
                                      preHash: latestAccountBlock?.hash,
                                      difficulty: difficulty).map { (latestAccountBlock, difficulty, $0) }
            }
            .map { (latestAccountBlock, difficulty, nonce) -> SendBlockContext in
                SendBlockContext(account: account,
                                 latest: latestAccountBlock,
                                 toAddress: toAddress,
                                 tokenId: tokenId,
                                 amount: amount,
                                 data: data,
                                 nonce: nonce,
                                 difficulty: difficulty)
        }
    }


    static func context(_ context: SendBlockContext) -> Promise<AccountBlock> {
        let send = AccountBlock.makeSendAccountBlock(secretKey: context.account.secretKey,
                                                     publicKey: context.account.publicKey,
                                                     address: context.account.address,
                                                     latest: context.latest,
                                                     toAddress: context.toAddress,
                                                     tokenId: context.tokenId,
                                                     amount: context.amount,
                                                     data: context.data,
                                                     nonce: context.nonce,
                                                     difficulty: context.difficulty)
        return ViteNode.tx.sendRawTx(accountBlock: send)
    }
}

public extension ViteNode.rawTx.receive {
    static func withoutPow(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<AccountBlock> {

        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<AccountBlock> in
                let receive = AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                                   publicKey: account.publicKey,
                                                                   address: account.address,
                                                                   onroadBlock: onroadBlock,
                                                                   latest: latestAccountBlock,
                                                                   nonce: nil,
                                                                   difficulty: nil)
                return ViteNode.tx.sendRawTx(accountBlock: receive)
        }
    }

    static func getPow(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<ReceiveBlockContext> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<(latestAccountBlock: AccountBlock?, difficulty: BigInt)> in
                ViteNode.tx.getPowDifficulty(accountAddress: account.address,
                                             prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                             type: .receive,
                                             toAddress: nil,
                                             data: nil,
                                             usePledgeQuota: false).map { (latestAccountBlock, $0) }
            }
            .then { (latestAccountBlock, difficulty) -> Promise<(latestAccountBlock: AccountBlock?, difficulty: BigInt, nonce: String)> in
                ViteNode.pow.getNonce(address: account.address,
                                      preHash: latestAccountBlock?.hash,
                                      difficulty: difficulty).map { (latestAccountBlock, difficulty, $0) }
            }
            .map { (latestAccountBlock, difficulty, nonce) -> ReceiveBlockContext in
                ReceiveBlockContext(account: account,
                                    onroadBlock: onroadBlock,
                                    latest: latestAccountBlock,
                                    nonce: nonce,
                                    difficulty: difficulty)
        }
    }

    static func context(_ context: ReceiveBlockContext) -> Promise<AccountBlock> {
        let receive = AccountBlock.makeReceiveAccountBlock(secretKey: context.account.secretKey,
                                                           publicKey: context.account.publicKey,
                                                           address: context.account.address,
                                                           onroadBlock: context.onroadBlock,
                                                           latest: context.latest,
                                                           nonce: context.nonce,
                                                           difficulty: context.difficulty)
        return ViteNode.tx.sendRawTx(accountBlock: receive)
    }
}
