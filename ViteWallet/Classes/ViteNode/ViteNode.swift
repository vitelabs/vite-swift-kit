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
    public struct pledge {}
    public struct rawTx {}
    public struct transaction {}
    public struct utils {}
    public struct vote {}
}

public struct SendBlockContext {
    let account: Wallet.Account
    let latest: AccountBlock?
    let toAddress: Address
    let tokenId: String
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
