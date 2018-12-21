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

    public func getPledgeQuota(address: Address) -> Promise<(UInt64, UInt64)> {
        let request = GetPledgeQuotaRequest(address: address.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
    }

    public func getPledges(address: Address, index: Int, count: Int) -> Promise<[Pledge]> {
        let request = GetPledgesRequest(address: address.description, index: index, count: count)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
    }

    public func pledgeWithoutPow(account: Wallet.Account,
                                 beneficialAddress: Address,
                                 amount: Balance) -> Promise<Void> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<Void> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: amount,
                                                data: data)
        }
    }

    public func getPowForPledge(account: Wallet.Account,
                                beneficialAddress: Address,
                                amount: Balance,
                                difficulty: BigInt) -> Promise<SendRawTxContext> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<SendRawTxContext> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.getPowForSendRawTx(account: account,
                                               toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                               tokenId: ViteWalletConst.viteToken.id,
                                               amount: amount,
                                               data: data,
                                               difficulty: difficulty)
        }
    }
}
