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
    let amount: Balance
    let data: Data?
    let nonce: String?
    let difficulty: BigInt?
}

public struct ReceiveBlockContext {
    let account: Wallet.Account
    let onroadBlock: AccountBlock
    let latest: AccountBlock?
    let nonce: String?
    let difficulty: BigInt?
}
