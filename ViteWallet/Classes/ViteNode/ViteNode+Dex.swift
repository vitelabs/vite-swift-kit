//
//  ViteNode+Dex.swift
//  ViteWallet
//
//  Created by Stone on 2019/9/9.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public extension ViteNode.dex {
    struct info {}
    struct perform {}
}

public extension ViteNode.dex.info {
    static func getDexBalanceInfos(address: ViteAddress, tokenId: ViteTokenId?) -> Promise<[DexBalanceInfo]> {
        return GetDexBalanceInfosRequest(address: address, tokenId: tokenId).defaultProviderPromise
    }

    static func getDexInviteCodeBinding(address: ViteAddress) -> Promise<Int64?> {
        return GetDexInviteCodeBindingRequest(address: address).defaultProviderPromise
    }

    static func checkDexInviteCode(inviteCode: Int64) -> Promise<Bool> {
        return CheckDexInviteCodeRequest(inviteCode: inviteCode).defaultProviderPromise
    }

    static func getDexVIPState(address: ViteAddress) -> Promise<Bool> {
        return GetDexVIPStateRequest(address: address).defaultProviderPromise
    }

    static func getDexSuperVIPState(address: ViteAddress) -> Promise<Bool> {
        return GetDexSuperVIPStateRequest(address: address).defaultProviderPromise
    }

    static func getDexMarketInfo(tradeTokenId: ViteTokenId, quoteTokenId: ViteTokenId) ->Promise<DexMarketInfo> {
        return GetDexMarketInfoRequest(tradeTokenId: tradeTokenId, quoteTokenId: quoteTokenId).defaultProviderPromise
    }


    static func getDexVIPStakeInfoList(address: ViteAddress, index: Int, count: Int) -> Promise<PledgeDetail> {
        return GetDexVIPStakeInfoListRequest(address: address, index: index, count: count).defaultProviderPromise
    }

    static func getDexMiningTradingInfo(address: ViteAddress) -> Promise<(DexMiningInfo, DexTradingMiningFeeInfo, DexAddressFeeInfo)> {
        let batch = BatchFactory().create(GetDexCurrentMiningInfoRequest(),
                                          GetDexMiningTradingFeeInfoRequest(),
                                          GetDexFeesByAddressRequest(address: address))
        return RPCRequest(for: Provider.default.server, batch: batch).promise
    }

    static func getDexMiningStakeInfo(address: ViteAddress) -> Promise<DexMiningStakeInfo> {
        let batch = BatchFactory().create(GetDexMiningStakeInfoRequest(address: address, index: 0, count: 50),
                                          GetDexMiningCancelStakeInfoRequest(address: address, index: 0, count: 50))
        return RPCRequest(for: Provider.default.server, batch: batch).promise.map { $0.0 }
    }

    static func getDexPlaceOrderInfo(address: ViteAddress, tradeTokenId: ViteTokenId, quoteTokenId: ViteTokenId, side: Bool) -> Promise<PlaceOrderInfo> {
        return GetDexPlaceOrderInfoRequest(address: address, tradeTokenId: tradeTokenId, quoteTokenId: quoteTokenId, side: side).defaultProviderPromise
    }

    static func getDexAccountFundInfo(address: ViteAddress, tokenId: ViteTokenId?) -> Promise<[ViteTokenId: DexAccountFundInfo]> {
        return GetDexAccountFundInfoRequest(address: address, tokenId: tokenId).defaultProviderPromise
    }

    static func getDexCurrentMiningStakingAmountByAddress(address: ViteAddress) -> Promise<Amount> {
        return GetDexCurrentMiningStakingAmountByAddressRequest(address: address).defaultProviderPromise
    }
}
