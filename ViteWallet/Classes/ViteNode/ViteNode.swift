//
//  ViteNode.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public struct ViteNode {
    public struct onroad {}
    public struct tx {}
    public struct ledger {}
    public struct pledge {}
    public struct vote {}
    public struct mintage {}
    public struct pow {}

    public struct rawTx {}
    public struct transaction {}
    public struct utils {}
}

public struct SendBlockContext {
    let account: Wallet.Account
    let latest: AccountBlock?
    let toAddress: ViteAddress
    let tokenId: ViteTokenId
    let amount: Amount
    let fee: Amount?
    let data: Data?

    public let quota: AccountBlockQuota

    let nonce: String?

    public var isNeedToCalcPoW: Bool {
        return quota.difficulty != nil
    }

    func toAccountBlock() -> AccountBlock {
        return AccountBlock.makeSendAccountBlock(secretKey: account.secretKey,
                                                 publicKey: account.publicKey,
                                                 address: account.address,
                                                 latest: latest,
                                                 toAddress: toAddress,
                                                 tokenId: tokenId,
                                                 amount: amount,
                                                 fee: fee,
                                                 data: data,
                                                 nonce: nonce,
                                                 difficulty: quota.difficulty)
    }
}

public struct ReceiveBlockContext {
    let account: Wallet.Account
    let onroadBlock: AccountBlock
    let latest: AccountBlock?

    public let quota: AccountBlockQuota

    let nonce: String?

    public var isNeedToCalcPoW: Bool {
        return quota.difficulty != nil
    }

    func toAccountBlock() -> AccountBlock {
        return AccountBlock.makeReceiveAccountBlock(secretKey: account.secretKey,
                                                    publicKey: account.publicKey,
                                                    address: account.address,
                                                    onroadBlock: onroadBlock,
                                                    latest: latest,
                                                    nonce: nonce,
                                                    difficulty: quota.difficulty)
    }
}
