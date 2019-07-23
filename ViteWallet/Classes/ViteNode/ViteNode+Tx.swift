//
//  ViteNode+Tx.swift
//  Pods
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.tx {

    static func sendRawTx(accountBlock: AccountBlock) -> Promise<AccountBlock> {
        return SendRawTxRequest(accountBlock: accountBlock).defaultProviderPromise.map({ _ in accountBlock })
    }

    static func getPowDifficulty(accountAddress: ViteAddress,
                                 prevHash: String,
                                 type: AccountBlock.BlockType,
                                 toAddress: ViteAddress?,
                                 data: Data?,
                                 usePledgeQuota: Bool) -> Promise<AccountBlockQuota> {

        return GetPowDifficultyRequest(accountAddress: accountAddress,
                                       prevHash: prevHash,
                                       type: type,
                                       toAddress: toAddress,
                                       data: data,
                                       usePledgeQuota: usePledgeQuota).defaultProviderPromise
    }
}
