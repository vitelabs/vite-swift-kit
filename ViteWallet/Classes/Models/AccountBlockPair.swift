//
//  AccountBlockPair.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/10.
//

import Foundation

public struct AccountBlockPair {
    public let send: AccountBlock
    public let receive: AccountBlock

    init(send: AccountBlock, receive: AccountBlock) {
        self.send = send
        self.receive = AccountBlock.merge(send: send, to: receive)
    }
}
