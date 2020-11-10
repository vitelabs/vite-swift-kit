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

    static func prepare(account: Wallet.Account,
                        blockType: AccountBlock.BlockType = .send,
                        toAddress: ViteAddress,
                        tokenId: ViteTokenId,
                        amount: Amount,
                        fee: Amount?,
                        data: Data?) -> Promise<SendBlockContext> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<(latestAccountBlock: AccountBlock?, quota: AccountBlockQuota)> in
                ViteNode.tx.getPowDifficulty(accountAddress: account.address,
                                             prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                             type: blockType,
                                             toAddress: toAddress,
                                             data: data,
                                             usePledgeQuota: true).map { (latestAccountBlock, $0) }
            }
            .map { (latestAccountBlock, quota) -> SendBlockContext in
                SendBlockContext(account: account,
                                 latest: latestAccountBlock,
                                 toAddress: toAddress,
                                 tokenId: tokenId,
                                 amount: amount,
                                 fee: fee,
                                 data: data,
                                 blockType: blockType,
                                 quota: quota,
                                 nonce: nil)
        }
    }

    static func block(account: Wallet.Account,
                      toAddress: ViteAddress,
                      tokenId: ViteTokenId,
                      amount: Amount,
                      fee: Amount?,
                      data: Data?) -> Promise<AccountBlock> {
        return ViteNode.rawTx.send.prepare(account: account,
                                           toAddress: toAddress,
                                           tokenId: tokenId,
                                           amount: amount,
                                           fee: fee,
                                           data: data)
            .then { (context) -> Promise<SendBlockContext> in
                if context.isNeedToCalcPoW {
                    return ViteNode.rawTx.send.getPow(context: context)
                } else {
                    return Promise.value(context)
                }
            }.then { context -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.context(context)
            }
    }

    static func getPow(context: SendBlockContext) -> Promise<SendBlockContext> {
        guard let difficulty = context.quota.difficulty else { return Promise(error: ViteError.JSONTypeError) }
        return ViteNode.pow.getNonce(address: context.account.address,
                                     preHash: context.latest?.hash,
                                     difficulty: difficulty)
            .map { nonce in
                SendBlockContext(account: context.account,
                                 latest: context.latest,
                                 toAddress: context.toAddress,
                                 tokenId: context.tokenId,
                                 amount: context.amount,
                                 fee: context.fee,
                                 data: context.data,
                                 blockType: context.blockType,
                                 quota: context.quota,
                                 nonce: nonce)
        }
    }

    static func withoutPow(account: Wallet.Account,
                           toAddress: ViteAddress,
                           tokenId: ViteTokenId,
                           amount: Amount,
                           fee: Amount?,
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
                                                             fee: fee,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return ViteNode.tx.sendRawTx(accountBlock: send)
        }
    }

    static func getPow(account: Wallet.Account,
                       toAddress: ViteAddress,
                       tokenId: ViteTokenId,
                       amount: Amount,
                       fee: Amount?,
                       data: Data?) -> Promise<SendBlockContext> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<(latestAccountBlock: AccountBlock?, quota: AccountBlockQuota)> in
                ViteNode.tx.getPowDifficulty(accountAddress: account.address,
                                             prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                             type: .send,
                                             toAddress: toAddress,
                                             data: data,
                                             usePledgeQuota: false).map { (latestAccountBlock, $0) }
            }
            .then { (latestAccountBlock, quota) -> Promise<(latestAccountBlock: AccountBlock?, quota: AccountBlockQuota, nonce: String)> in
                guard let difficulty = quota.difficulty else { throw ViteError.JSONTypeError }
                return ViteNode.pow.getNonce(address: account.address,
                                      preHash: latestAccountBlock?.hash,
                                      difficulty: difficulty).map { (latestAccountBlock, quota, $0) }
            }
            .map { (latestAccountBlock, quota, nonce) -> SendBlockContext in
                SendBlockContext(account: account,
                                 latest: latestAccountBlock,
                                 toAddress: toAddress,
                                 tokenId: tokenId,
                                 amount: amount,
                                 fee: fee,
                                 data: data,
                                 blockType: .send,
                                 quota: quota,
                                 nonce: nonce)
        }
    }


    static func context(_ context: SendBlockContext) -> Promise<AccountBlock> {
        return ViteNode.tx.sendRawTx(accountBlock: context.toAccountBlock())
    }
}

public extension ViteNode.rawTx.receive {

    static func prepare(account: Wallet.Account, onroadBlock: AccountBlock) -> Promise<ReceiveBlockContext> {
        return ViteNode.ledger.getLatestAccountBlock(address: account.address)
            .then { latestAccountBlock -> Promise<(latestAccountBlock: AccountBlock?, quota: AccountBlockQuota)> in
                ViteNode.tx.getPowDifficulty(accountAddress: account.address,
                                             prevHash: latestAccountBlock?.hash ?? AccountBlock.Const.defaultHash,
                                             type: .receive,
                                             toAddress: nil,
                                             data: nil,
                                             usePledgeQuota: true).map { (latestAccountBlock, $0) }
            }
            .map { (latestAccountBlock, quota) -> ReceiveBlockContext in
                ReceiveBlockContext(account: account,
                                    onroadBlock: onroadBlock,
                                    latest: latestAccountBlock,
                                    quota: quota,
                                    nonce: nil)
        }
    }

    static func getPow(context: ReceiveBlockContext) -> Promise<ReceiveBlockContext> {
        guard let difficulty = context.quota.difficulty else { return Promise(error: ViteError.JSONTypeError) }
        return ViteNode.pow.getNonce(address: context.account.address,
                                     preHash: context.latest?.hash,
                                     difficulty: difficulty)
            .map { nonce in
                ReceiveBlockContext(account: context.account,
                                    onroadBlock: context.onroadBlock,
                                    latest: context.latest,
                                    quota: context.quota,
                                    nonce: nonce)
        }
    }

    static func context(_ context: ReceiveBlockContext) -> Promise<AccountBlock> {
        return ViteNode.tx.sendRawTx(accountBlock: context.toAccountBlock())
    }
}
