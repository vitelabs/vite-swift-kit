//
//  ViteNode+Pledge.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/10.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.pledge {
    public struct info {}
    public struct perform {}
    public struct cancel {}
}

public extension ViteNode.pledge.info {
    static func getPledgeQuota(address: ViteAddress) -> Promise<Quota> {
        return GetPledgeQuotaRequest(address: address).defaultProviderPromise
    }

    static func getPledgeDetail(address: ViteAddress, index: Int, count: Int) -> Promise<PledgeDetail> {
        return GetPledgeDetailRequest(address: address, index: index, count: count).defaultProviderPromise
    }

    static func getPledgeBeneficialAmount(address: ViteAddress) -> Promise<Amount> {
        return GetPledgeBeneficialAmountRequest(address: address).defaultProviderPromise
    }
}

public extension ViteNode.pledge.perform {
    static func withoutPow(account: Wallet.Account,
                           beneficialAddress: ViteAddress,
                           amount: Amount) -> Promise<AccountBlock> {
        return GetPledgeDataRequest(beneficialAddress: beneficialAddress).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: amount,
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account,
                       beneficialAddress: ViteAddress,
                       amount: Amount) -> Promise<SendBlockContext> {
        return GetPledgeDataRequest(beneficialAddress: beneficialAddress).defaultProviderPromise
            .then { data -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account,
                                                  toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                  tokenId: ViteWalletConst.viteToken.id,
                                                  amount: amount,
                                                  data: data)
        }
    }
}

public extension ViteNode.pledge.cancel {

    static func withoutPow(account: Wallet.Account,
                           beneficialAddress: ViteAddress,
                           amount: Amount) -> Promise<AccountBlock> {
        return GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress, amount: amount).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: Amount(),
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account,
                       beneficialAddress: ViteAddress,
                       amount: Amount) -> Promise<SendBlockContext> {
        return GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress, amount: amount).defaultProviderPromise
            .then { data -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account,
                                                  toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                  tokenId: ViteWalletConst.viteToken.id,
                                                  amount: Amount(),
                                                  data: data)
        }
    }
}
