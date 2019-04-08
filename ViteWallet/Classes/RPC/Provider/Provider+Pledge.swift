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

// MARK: Get Info
extension Provider {
    public func getPledgeQuota(address: Address) -> Promise<Quota> {
        let request = GetPledgeQuotaRequest(address: address.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
    }

    public func getPledges(address: Address, index: Int, count: Int) -> Promise<[Pledge]> {
        let request = GetPledgesRequest(address: address.description, index: index, count: count)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
    }
}

// MARK: Pledge
extension Provider {
    public func pledgeWithoutPow(account: Wallet.Account,
                                 beneficialAddress: Address,
                                 amount: Balance) -> Promise<AccountBlock> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<AccountBlock> in
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
                                amount: Balance) -> Promise<SendBlockContext> {
        let request = GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<SendBlockContext> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.getPowForSendRawTx(account: account,
                                               toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                               tokenId: ViteWalletConst.viteToken.id,
                                               amount: amount,
                                               data: data)
        }
    }
}

// MARK: Cancel Pledge
extension Provider {
    public func cancelPledgeWithoutPow(account: Wallet.Account,
                                       beneficialAddress: Address,
                                       amount: Balance) -> Promise<AccountBlock> {
        let request = GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress.description, amount: amount)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<AccountBlock> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.sendRawTxWithoutPow(account: account,
                                                toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                tokenId: ViteWalletConst.viteToken.id,
                                                amount: Balance(),
                                                data: data)
        }
    }

    public func getPowForCancelPledge(account: Wallet.Account,
                                      beneficialAddress: Address,
                                      amount: Balance) -> Promise<SendBlockContext> {
        let request = GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress.description, amount: amount)
        return RPCRequest(for: server, batch: BatchFactory().create(request)).promise
            .then { [weak self] data -> Promise<SendBlockContext> in
                guard let `self` = self else { return Promise(error: ViteError.cancelError) }
                return self.getPowForSendRawTx(account: account,
                                               toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                               tokenId: ViteWalletConst.viteToken.id,
                                               amount: Balance(),
                                               data: data)
        }
    }
}
