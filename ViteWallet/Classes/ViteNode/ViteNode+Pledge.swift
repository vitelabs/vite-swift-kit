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
    static func getPledgeQuota(address: Address) -> Promise<Quota> {
        return GetPledgeQuotaRequest(address: address.description).defaultProviderPromise
    }

    static func getPledges(address: Address, index: Int, count: Int) -> Promise<[Pledge]> {
        return GetPledgesRequest(address: address.description, index: index, count: count).defaultProviderPromise
    }
}

public extension ViteNode.pledge.perform {
    static func withoutPow(account: Wallet.Account,
                           beneficialAddress: Address,
                           amount: Balance) -> Promise<AccountBlock> {
        return GetPledgeDataRequest(beneficialAddress: beneficialAddress.description).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: amount,
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account,
                       beneficialAddress: Address,
                       amount: Balance) -> Promise<SendBlockContext> {
        return GetPledgeDataRequest(beneficialAddress: beneficialAddress.description).defaultProviderPromise
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
                           beneficialAddress: Address,
                           amount: Balance) -> Promise<AccountBlock> {
        return GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress.description, amount: amount).defaultProviderPromise
            .then { data -> Promise<AccountBlock> in
                return ViteNode.rawTx.send.withoutPow(account: account,
                                                      toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                      tokenId: ViteWalletConst.viteToken.id,
                                                      amount: Balance(),
                                                      data: data)
        }
    }

    static func getPow(account: Wallet.Account,
                       beneficialAddress: Address,
                       amount: Balance) -> Promise<SendBlockContext> {
        return GetCancelPledgeDataRequest(beneficialAddress: beneficialAddress.description, amount: amount).defaultProviderPromise
            .then { data -> Promise<SendBlockContext> in
                return ViteNode.rawTx.send.getPow(account: account,
                                                  toAddress: ViteWalletConst.ContractAddress.pledge.address,
                                                  tokenId: ViteWalletConst.viteToken.id,
                                                  amount: Balance(),
                                                  data: data)
        }
    }
}
