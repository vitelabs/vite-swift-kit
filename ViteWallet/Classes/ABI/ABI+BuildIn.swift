//
//  ABI+Extension.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import BigInt

public extension ABI {

    enum BuildIn: String, CaseIterable {

        case register = "{\"type\":\"function\",\"name\":\"Register\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
        case registerUpdate = "{\"type\":\"function\",\"name\":\"UpdateRegistration\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"Name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
        case cancelRegister = "{\"type\":\"function\",\"name\":\"CancelRegister\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"}]}"
        case extractReward = "{\"type\":\"function\",\"name\":\"Reward\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"beneficialAddr\",\"type\":\"address\"}]}"

        case vote = "{\"type\":\"function\",\"name\":\"Vote\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"nodeName\",\"type\":\"string\"}]}"
        case cancelVote = "{\"type\":\"function\",\"name\":\"CancelVote\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"}]}"
        case pledge = "{\"type\":\"function\",\"name\":\"Pledge\", \"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"}]}"
        case cancelPledge = "{\"type\":\"function\",\"name\":\"CancelPledge\",\"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"

        case coinMint = "{\"type\":\"function\",\"name\":\"Mint\",\"inputs\":[{\"name\":\"isReIssuable\",\"type\":\"bool\"},{\"name\":\"tokenName\",\"type\":\"string\"},{\"name\":\"tokenSymbol\",\"type\":\"string\"},{\"name\":\"totalSupply\",\"type\":\"uint256\"},{\"name\":\"decimals\",\"type\":\"uint8\"},{\"name\":\"maxSupply\",\"type\":\"uint256\"},{\"name\":\"ownerBurnOnly\",\"type\":\"bool\"}]}"
        case coinIssue = "{\"type\":\"function\",\"name\":\"Issue\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"},{\"name\":\"amount\",\"type\":\"uint256\"},{\"name\":\"beneficial\",\"type\":\"address\"}]}"
        case coinBurn = "{\"type\":\"function\",\"name\":\"Burn\",\"inputs\":[]}"
        case coinTransferOwner = "{\"type\":\"function\",\"name\":\"TransferOwner\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"},{\"name\":\"newOwner\",\"type\":\"address\"}]}"
        case coinChangeTokenType = "{\"type\":\"function\",\"name\":\"ChangeTokenType\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"}]}"

        case dexDeposit = "{\"type\":\"function\",\"name\":\"DexFundUserDeposit\",\"inputs\":[]}"
        case dexWithdraw = "{\"type\":\"function\",\"name\":\"DexFundUserWithdraw\",\"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case dexPost = "{\"type\":\"function\",\"name\":\"DexFundNewOrder\",\"inputs\":[{\"name\":\"tradeToken\",\"type\":\"tokenId\"},{\"name\":\"quoteToken\",\"type\":\"tokenId\"},{\"name\":\"side\",\"type\":\"bool\"},{\"name\":\"orderType\",\"type\":\"uint8\"},{\"name\":\"price\",\"type\":\"string\"},{\"name\":\"quantity\",\"type\":\"uint256\"}]}"
        case dexCancel = "{\"type\":\"function\",\"name\":\"DexTradeCancelOrder\",\"inputs\":[{\"name\":\"orderId\",\"type\":\"bytes\"}]}"

        case dexNewInviter = "{\"type\":\"function\",\"name\":\"DexFundNewInviter\",\"inputs\":[]}"
        case dexBindInviter = "{\"type\":\"function\",\"name\":\"DexFundBindInviteCode\",\"inputs\":[{\"name\":\"code\",\"type\":\"uint32\"}]}"

        case dexTransferTokenOwner = "{\"type\":\"function\",\"name\":\"DexFundTransferTokenOwner\",\"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"},{\"name\":\"owner\",\"type\":\"address\"}]}"
        case dexNewMarket = "{\"type\":\"function\",\"name\":\"DexFundNewMarket\",\"inputs\":[{\"name\":\"tradeToken\",\"type\":\"tokenId\"},{\"name\":\"quoteToken\",\"type\":\"tokenId\"}]}"
        case dexMarketConfig = "{\"type\":\"function\",\"name\":\"DexFundMarketOwnerConfig\",\"inputs\":[{\"name\":\"operationCode\",\"type\":\"uint8\"},{\"name\":\"tradeToken\",\"type\":\"tokenId\"},{\"name\":\"quoteToken\",\"type\":\"tokenId\"},{\"name\":\"owner\",\"type\":\"address\"},{\"name\":\"takerFeeRate\",\"type\":\"int32\"},{\"name\":\"makerFeeRate\",\"type\":\"int32\"},{\"name\":\"stopMarket\",\"type\":\"bool\"}]}"

        case dexStakingAsMining = "{\"type\":\"function\",\"name\":\"DexFundPledgeForVx\",\"inputs\":[{\"name\":\"actionType\",\"type\":\"uint8\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case dexVip = "{\"type\":\"function\",\"name\":\"DexFundPledgeForVip\",\"inputs\":[{\"name\":\"actionType\",\"type\":\"uint8\"}]}"

        case registerSBP = "{\"type\":\"function\",\"name\":\"RegisterSBP\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"blockProducingAddress\",\"type\":\"address\"},{\"name\":\"rewardWithdrawAddress\",\"type\":\"address\"}]}"
        case voteForSBP = "{\"type\":\"function\",\"name\":\"VoteForSBP\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"}]}"
        case CancelSBPVoting = " {\"type\":\"function\",\"name\":\"CancelSBPVoting\",\"inputs\":[]}"
        case StakeForQuota = "{\"type\":\"function\",\"name\":\"StakeForQuota\", \"inputs\":[{\"name\":\"beneficiary\",\"type\":\"address\"}]}"
        case CancelQuotaStaking = "{\"type\":\"function\",\"name\":\"CancelQuotaStaking\",\"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\"}]}"

        case defiDeposit = "{\"type\":\"function\",\"name\":\"Deposit\",\"inputs\":[]}"
        case defiWithdraw = "{\"type\":\"function\",\"name\":\"Withdraw\",\"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case defiNewLoan = "{\"type\":\"function\",\"name\":\"NewLoan\",\"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"},{\"name\":\"dayRate\",\"type\":\"int32\"},{\"name\":\"shareAmount\",\"type\":\"uint256\"},{\"name\":\"shares\",\"type\":\"int32\"},{\"name\":\"subscribeDays\",\"type\":\"int32\"},{\"name\":\"expireDays\",\"type\":\"int32\"}]}"
        case defiCancelLoan = "{\"type\":\"function\",\"name\":\"CancelLoan\",\"inputs\":[{\"name\":\"loanId\",\"type\":\"uint64\"}]}"
        case defiSubscribe = "{\"type\":\"function\",\"name\":\"Subscribe\",\"inputs\":[{\"name\":\"loanId\",\"type\":\"uint64\"},{\"name\":\"shares\",\"type\":\"int32\"}]}"
        case defiRegisterSBP = "{\"type\":\"function\",\"name\":\"RegisterSBP\",\"inputs\":[{\"name\":\"loadId\",\"type\":\"uint64\"},{\"name\":\"amount\",\"type\":\"uint256\"},{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"blockProducingAddress\",\"type\":\"address\"},{\"name\":\"rewardWithdrawAddress\",\"type\":\"address\"}]}"
        case defiUpdateSBPRegistration = "{\"type\":\"function\",\"name\":\"UpdateSBPRegistration\",\"inputs\":[{\"name\":\"investId\",\"type\":\"uint64\"},{\"name\":\"operationCode\",\"type\":\"uint8\"},{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"blockProducingAddress\",\"type\":\"address\"},{\"name\":\"rewardWithdrawAddress\",\"type\":\"address\"}]}"
        case defiInvest = "{\"type\":\"function\",\"name\":\"Invest\",\"inputs\":[{\"name\":\"loadId\",\"type\":\"uint64\"},{\"name\":\"bizType\",\"type\":\"uint8\"},{\"name\":\"amount\",\"type\":\"uint256\"},{\"name\":\"beneficiary\",\"type\":\"address\"}]}"
        case defiCancelInvest = "{\"type\":\"function\",\"name\":\"CancelInvest\",\"inputs\":[{\"name\":\"investId\",\"type\":\"uint64\"}]}"


        public var encodedFunctionSignature: Data {
            return try! ABI.Encoding.encodeFunctionSignature(abiString: self.rawValue)
        }

        public var abiRecord: ABI.Record {
            return ABI.Record.tryToConvertToFunctionRecord(abiString: self.rawValue)!
        }

        public var ut: Double {
            switch self {
            case .register:
                 return 8
            case .registerSBP:
                return 8
            case .registerUpdate:
                return 8
            case .cancelRegister:
                return 6
            case .extractReward:
                return 7

            case .vote, .voteForSBP:
                return 4
            case .cancelVote, .CancelSBPVoting:
                return 2.5
            case .pledge, .StakeForQuota:
                return 5
            case .cancelPledge, .CancelQuotaStaking:
                return 5

            case .coinMint:
                return 9
            case .coinIssue:
                return 6
            case .coinBurn:
                return 5.5
            case .coinTransferOwner:
                return 6.5
            case .coinChangeTokenType:
                return 5.5
            case .dexDeposit:
                return 1.0130
            case .dexWithdraw:
                return 1.2202
            case .dexPost:
                return 1.8419
            case .dexCancel:
                return 1.3238

            case .dexNewInviter:
                return 1.0130
            case .dexBindInviter:
                return 1.1166

            case .dexTransferTokenOwner:
                return 1.2202
            case .dexNewMarket:
                return 1.2202
            case .dexMarketConfig:
                return 1.7383
            case .dexStakingAsMining:
                return 1.2202
            case .dexVip:
                return 1.1166
            case .defiDeposit:
                return 1.111111111111111
            case .defiWithdraw:
                return 1.111111111111111
            case .defiNewLoan:
                return 1.111111111111111
            case .defiCancelLoan:
                return 1.111111111111111
            case .defiSubscribe:
                return 1.111111111111111
            case .defiRegisterSBP:
                return 1.111111111111111
            case .defiUpdateSBPRegistration:
                return 1.111111111111111
            case .defiInvest:
                return 1.111111111111111
            case .defiCancelInvest:
                return 1.111111111111111
            }
        }

        public var toAddress: ViteAddress {
            switch self {
            case .register,.registerSBP, .registerUpdate, .cancelRegister, .extractReward, .vote, .cancelVote, .voteForSBP, .CancelSBPVoting:
                return ViteWalletConst.ContractAddress.consensus.address
            case .pledge, .cancelPledge, .StakeForQuota, .CancelQuotaStaking:
                return ViteWalletConst.ContractAddress.pledge.address
            case .coinMint, .coinIssue, .coinBurn, .coinTransferOwner, .coinChangeTokenType:
                return ViteWalletConst.ContractAddress.coin.address
                case .dexDeposit, .dexWithdraw, .dexPost,
                     .dexNewInviter, .dexBindInviter,
                     .dexTransferTokenOwner, .dexNewMarket, .dexMarketConfig,
                     .dexStakingAsMining, .dexVip:
                return ViteWalletConst.ContractAddress.dexFund.address
            case .dexCancel:
                return ViteWalletConst.ContractAddress.dexTrade.address
            case .defiDeposit, .defiWithdraw, .defiNewLoan, .defiCancelLoan, .defiSubscribe,
                 .defiRegisterSBP, .defiUpdateSBPRegistration, .defiInvest, .defiCancelInvest:
                return ViteWalletConst.ContractAddress.defi.address
            }
        }

        fileprivate static let toAddressAndDataPrefixMap: [String: BuildIn] =
            BuildIn.allCases.reduce([String: BuildIn]()) { (r, t) -> [String: BuildIn] in
                var ret = r
                let key = "\(t.toAddress)_\(t.encodedFunctionSignature.toHexString())"
                ret[key] = t
                return ret
        }

        public static func type(data: Data?, toAddress: ViteAddress) -> (BuildIn, [ABIParameterValue])? {
            if let data = data, data.count >= 4,
                let type = toAddressAndDataPrefixMap["\(toAddress)_\(data[0..<4].toHexString())"] {
                do {
                    let values = try ABI.Decoding.decodeParameters(data, abiString: type.rawValue)
                    return (type, values)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }

//        public static func getVoteData(gid: ViteGId, name: String) -> Data {
//            return getData(type: .vote, values: [gid, name])
//        }

        public static func getVoteForSBPData(name: String) -> Data {
            return getData(type: .voteForSBP, values: [name])
        }

//        public static func getCancelVoteData(gid: ViteGId) -> Data {
//            return getData(type: .cancelVote, values: [gid])
//        }

        public static func getCancelSBPVotingData() -> Data {
            return getData(type: .CancelSBPVoting, values: [])
        }

//        public static func getPledgeData(beneficialAddress: ViteAddress) -> Data {
//            return getData(type: .pledge, values: [beneficialAddress])
//        }

        public static func getStakeForQuota(beneficialAddress: ViteAddress) -> Data {
            return getData(type: .StakeForQuota, values: [beneficialAddress])
        }

        public static func getCancelPledgeData(beneficialAddress: ViteAddress, amount: Amount) -> Data {
            return getData(type: .cancelPledge, values: [beneficialAddress, amount.description])
        }

        public static func getCancelQuotaStakingData(id: String) -> Data {
            return getData(type: .CancelQuotaStaking, values: [id])
        }

        public static func getDexDepositData() -> Data {
            return getData(type: .dexDeposit, values: [])
        }

        public static func getDexWithdrawData(tokenId: ViteTokenId, amount: Amount) -> Data {
            return getData(type: .dexWithdraw, values: [tokenId, amount.description])
        }

        public static func getDexBindInviterData(code: String) -> Data {
            return getData(type: .dexBindInviter, values: [code])
        }


        private static func getData(type: BuildIn, values: [String]) -> Data {
            do {
                let json = try JSONEncoder().encode(values)
                let valuesString = String(bytes: json, encoding: .utf8) ?? ""
                return try ABI.Encoding.encodeFunctionCall(abiString: type.rawValue, valuesString: valuesString)
            } catch {
                return Data()
            }
        }
    }
}

extension ABI.BuildIn {
    //MARK: DeFi

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
                                                                  sbpName,
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



