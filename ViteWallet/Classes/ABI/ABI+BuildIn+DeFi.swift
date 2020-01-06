//
//  ABI+BuildIn+DeFi.swift
//  ViteWallet
//
//  Created by Stone on 2020/1/6.
//

import BigInt

extension ABI.BuildIn {

    public static func getDeFiDepositData() -> Data {
        return getData(type: .defiDeposit, values: [])
    }

    public static func getDeFiWithdrawData(tokenId: ViteTokenId, amount: Amount) -> Data {
        return getData(type: .defiWithdraw, values: [tokenId, amount.description])
    }

    public static func getDeFiNewLoanData(tokenId: ViteTokenId,
                                          dayRate: Decimal,
                                          shareAmount: Amount,
                                          shares: UInt64,
                                          subscribeDays: UInt64,
                                          expireDays: UInt64) -> Data {
        return getData(type: .defiNewLoan, values: [tokenId,
                                                    (dayRate * 1000000).description,
                                                    shareAmount.description,
                                                    String(shares),
                                                    String(subscribeDays),
                                                    String(expireDays)])
    }

    public static func getDeFiCancelLoanData(loanId: UInt64) -> Data {
        return getData(type: .defiCancelLoan, values: [String(loanId)])
    }

    public static func getDeFiSubscribeData(loanId: UInt64, shares: UInt64) -> Data {
        return getData(type: .defiSubscribe, values: [String(loanId), String(shares)])
    }

    public static func getDeFiRegisterSBPData(loanId: UInt64,
                                              amount: Amount,
                                              sbpName: String,
                                              blockProducingAddress: ViteAddress,
                                              rewardWithdrawAddress: ViteAddress) -> Data {
        return getData(type: .defiRegisterSBP, values: [String(loanId),
                                                        amount.description,
                                                        sbpName,
                                                        blockProducingAddress,
                                                        rewardWithdrawAddress])
    }

    public static func getDeFiUpdateSBPRegistrationData(investId: UInt64,
                                                        operationCode: UInt8,
                                                        sbpName: String,
                                                        blockProducingAddress: ViteAddress,
                                                        rewardWithdrawAddress: ViteAddress) -> Data {
        return getData(type: .defiUpdateSBPRegistration, values: [String(investId),
                                                                  String(operationCode),
                                                                  blockProducingAddress,
                                                                  rewardWithdrawAddress])
    }

    public static func getDeFiInvestData(loanId: UInt64,
                                         bizType: UInt8,
                                         amount: Amount,
                                         beneficiaryAddress: ViteAddress) -> Data {
        return getData(type: .defiInvest, values: [String(loanId),
                                                   String(bizType),
                                                   amount.description,
                                                   beneficiaryAddress])
    }

    public static func getDeFiCancelInvestData(investId: UInt64) -> Data {
        return getData(type: .defiCancelInvest, values: [String(investId)])
    }
}
