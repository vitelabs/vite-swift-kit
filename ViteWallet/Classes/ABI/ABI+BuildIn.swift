//
//  ABI+BuildIn.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import BigInt

public extension ABI {

    enum BuildIn: String, CaseIterable {

        // MARK: SBP
        case old_register = "{\"type\":\"function\",\"name\":\"Register\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
        case old_registerUpdate = "{\"type\":\"function\",\"name\":\"UpdateRegistration\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"Name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
        case old_cancelRegister = "{\"type\":\"function\",\"name\":\"CancelRegister\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"}]}"
        case old_extractReward = "{\"type\":\"function\",\"name\":\"Reward\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"beneficialAddr\",\"type\":\"address\"}]}"
        case registerSBP = "{\"type\":\"function\",\"name\":\"RegisterSBP\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"blockProducingAddress\",\"type\":\"address\"},{\"name\":\"rewardWithdrawAddress\",\"type\":\"address\"}]}"
        case updateSBPBlockProducingAddress = "{\"type\":\"function\",\"name\":\"UpdateSBPBlockProducingAddress\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"blockProducingAddress\",\"type\":\"address\"}]}"
        case updateSBPRewardWithdrawAddress = "{\"type\":\"function\",\"name\":\"UpdateSBPRewardWithdrawAddress\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"rewardWithdrawAddress\",\"type\":\"address\"}]}"
        case revokeSBP = "{\"type\":\"function\",\"name\":\"RevokeSBP\",\"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"}]}"
        case withdrawSBPReward = "{\"type\":\"function\",\"name\":\"WithdrawSBPReward\",\"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"},{\"name\":\"receiveAddress\",\"type\":\"address\"}]}"

        // MARK: Vote
        case old_vote = "{\"type\":\"function\",\"name\":\"Vote\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"nodeName\",\"type\":\"string\"}]}"
        case old_cancelVote = "{\"type\":\"function\",\"name\":\"CancelVote\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"}]}"
        case voteForSBP = "{\"type\":\"function\",\"name\":\"VoteForSBP\", \"inputs\":[{\"name\":\"sbpName\",\"type\":\"string\"}]}"
        case cancelSBPVoting = " {\"type\":\"function\",\"name\":\"CancelSBPVoting\",\"inputs\":[]}"

        // MARK: Stake
        case old_pledge = "{\"type\":\"function\",\"name\":\"Pledge\", \"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"}]}"
        case old_cancelPledge = "{\"type\":\"function\",\"name\":\"CancelPledge\",\"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case old_cancelStake = "{\"type\":\"function\",\"name\":\"CancelStake\",\"inputs\":[{\"name\":\"beneficiary\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case stakeForQuota = "{\"type\":\"function\",\"name\":\"StakeForQuota\", \"inputs\":[{\"name\":\"beneficiary\",\"type\":\"address\"}]}"
        case cancelQuotaStaking = "{\"type\":\"function\",\"name\":\"CancelQuotaStaking\",\"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\"}]}"

        // MARK: Coin
        case coinIssueToken = "{\"type\":\"function\",\"name\":\"IssueToken\",\"inputs\":[{\"name\":\"isReIssuable\",\"type\":\"bool\"},{\"name\":\"tokenName\",\"type\":\"string\"},{\"name\":\"tokenSymbol\",\"type\":\"string\"},{\"name\":\"totalSupply\",\"type\":\"uint256\"},{\"name\":\"decimals\",\"type\":\"uint8\"},{\"name\":\"maxSupply\",\"type\":\"uint256\"},{\"name\":\"isOwnerBurnOnly\",\"type\":\"bool\"}]}"
        case coinReIssue = "{\"type\":\"function\",\"name\":\"ReIssue\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"},{\"name\":\"amount\",\"type\":\"uint256\"},{\"name\":\"receiveAddress\",\"type\":\"address\"}]}"
        case coinBurn = "{\"type\":\"function\",\"name\":\"Burn\",\"inputs\":[]}"
        case coinTransferOwnership = "{\"type\":\"function\",\"name\":\"TransferOwnership\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"},{\"name\":\"newOwner\",\"type\":\"address\"}]}"
        case coinChangeTokenType = "{\"type\":\"function\",\"name\":\"DisableReIssue\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"tokenId\"}]}"

        // MARK: Dex
        case dexDeposit = "{\"type\":\"function\",\"name\":\"Deposit\", \"inputs\":[]}"
        case dexWithdraw = "{\"type\":\"function\",\"name\":\"Withdraw\", \"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case dexPlaceOrder = "{\"type\":\"function\",\"name\":\"PlaceOrder\", \"inputs\":[{\"name\":\"tradeToken\",\"type\":\"tokenId\"}, {\"name\":\"quoteToken\",\"type\":\"tokenId\"}, {\"name\":\"side\", \"type\":\"bool\"}, {\"name\":\"orderType\", \"type\":\"uint8\"}, {\"name\":\"price\", \"type\":\"string\"}, {\"name\":\"quantity\", \"type\":\"uint256\"}]}"
        case dexCancelOrder = "{\"type\":\"function\",\"name\":\"CancelOrderByTransactionHash\", \"inputs\":[{\"name\":\"sendHash\",\"type\":\"bytes32\"}]}"

        case dexCreateInviteCode = "{\"type\":\"function\",\"name\":\"CreateNewInviter\", \"inputs\":[]}"
        case dexBindInviteCode = "{\"type\":\"function\",\"name\":\"BindInviteCode\", \"inputs\":[{\"name\":\"code\",\"type\":\"uint32\"}]}"

        case dexTransferTokenOwnership = "{\"type\":\"function\",\"name\":\"TransferTokenOwnership\", \"inputs\":[{\"name\":\"token\",\"type\":\"tokenId\"}, {\"name\":\"newOwner\",\"type\":\"address\"}]}"
        case dexOpenNewMarket = "{\"type\":\"function\",\"name\":\"OpenNewMarket\", \"inputs\":[{\"name\":\"tradeToken\",\"type\":\"tokenId\"}, {\"name\":\"quoteToken\",\"type\":\"tokenId\"}]}"
        case dexMarketAdminConfig = "{\"type\":\"function\",\"name\":\"MarketAdminConfig\", \"inputs\":[{\"name\":\"operationCode\",\"type\":\"uint8\"},{\"name\":\"tradeToken\",\"type\":\"tokenId\"},{\"name\":\"quoteToken\",\"type\":\"tokenId\"},{\"name\":\"marketOwner\",\"type\":\"address\"},{\"name\":\"takerFeeRate\",\"type\":\"int32\"},{\"name\":\"makerFeeRate\",\"type\":\"int32\"},{\"name\":\"stopMarket\",\"type\":\"bool\"}]}"

        case dexStakeForMining = "{\"type\":\"function\",\"name\":\"StakeForMining\", \"inputs\":[{\"name\":\"actionType\",\"type\":\"uint8\"}, {\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case dexStakeForVIP = "{\"type\":\"function\",\"name\":\"StakeForVIP\", \"inputs\":[{\"name\":\"actionType\",\"type\":\"uint8\"}]}"
        case dexLockVxForDividend = "{\"type\":\"function\",\"name\":\"LockVxForDividend\", \"inputs\":[{\"name\":\"actionType\",\"type\":\"uint8\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
        case dexCancelStakeById = "{\"type\":\"function\",\"name\":\"CancelStakeById\", \"inputs\":[{\"name\":\"id\",\"type\":\"bytes32\"}]}"
        case dexSwitchConfig = "{\"type\":\"function\",\"name\":\"SwitchConfig\",\"inputs\":[{\"name\":\"switchType\",\"type\":\"uint8\"},{\"name\":\"enable\",\"type\":\"bool\"}]}"
        

        public var encodedFunctionSignature: Data {
            return try! ABI.Encoding.encodeFunctionSignature(abiString: self.rawValue)
        }

        public var abiRecord: ABI.Record {
            return ABI.Record.tryToConvertToFunctionRecord(abiString: self.rawValue)!
        }

        public var ut: Double {
            switch self {
            case .old_register:
                 return 8
            case .old_registerUpdate:
                return 8
            case .old_cancelRegister:
                return 6
            case .old_extractReward:
                return 7


            case .registerSBP:
                return 8
            case .updateSBPBlockProducingAddress:
                return 8
            case .updateSBPRewardWithdrawAddress:
                return 8
            case .revokeSBP:
                return 6
            case .withdrawSBPReward:
                return 7


            case .old_vote:
                return 4
            case .old_cancelVote:
                return 2.5
            case .voteForSBP:
                return 4
            case .cancelSBPVoting:
                return 2.5


            case .old_pledge:
                return 5
            case .old_cancelPledge:
                return 5
            case .old_cancelStake:
                return 5
            case .stakeForQuota:
                return 5
            case .cancelQuotaStaking:
                return 5


            case .coinIssueToken:
                return 9
            case .coinReIssue:
                return 6
            case .coinBurn:
                return 5.5
            case .coinTransferOwnership:
                return 6.5
            case .coinChangeTokenType:
                return 5.5


            case .dexDeposit:
                return 1.0130
            case .dexWithdraw:
                return 1.2202
            case .dexPlaceOrder:
                return 1.8419
            case .dexCancelOrder:
                return 1.3238

            case .dexCreateInviteCode:
                return 1.0130
            case .dexBindInviteCode:
                return 1.1166

            case .dexTransferTokenOwnership:
                return 1.2202
            case .dexOpenNewMarket:
                return 1.2202
            case .dexMarketAdminConfig:
                return 1.7383
            case .dexStakeForMining:
                return 1.2202
            case .dexStakeForVIP:
                return 1.1166
            case .dexLockVxForDividend:
                return 1.2202
            case .dexCancelStakeById:
                return 1.117
            case .dexSwitchConfig:
                return 1.091
            }
        }

        public var toAddress: ViteAddress {
            switch self {
            case .old_register, .old_registerUpdate, .old_cancelRegister, .old_extractReward,
                 .registerSBP, .updateSBPBlockProducingAddress, .updateSBPRewardWithdrawAddress, .revokeSBP, .withdrawSBPReward,
                 .old_vote, .old_cancelVote,
                 .voteForSBP, .cancelSBPVoting:
                return ViteWalletConst.ContractAddress.consensus.address
            case .old_pledge, .old_cancelPledge,
                 .old_cancelStake, .stakeForQuota, .cancelQuotaStaking:
                return ViteWalletConst.ContractAddress.pledge.address
            case .coinIssueToken, .coinReIssue, .coinBurn, .coinTransferOwnership, .coinChangeTokenType:
                return ViteWalletConst.ContractAddress.coin.address
            case .dexDeposit, .dexWithdraw, .dexPlaceOrder,
                     .dexCreateInviteCode, .dexBindInviteCode,
                     .dexTransferTokenOwnership, .dexOpenNewMarket, .dexMarketAdminConfig,
                     .dexStakeForMining, .dexStakeForVIP, .dexLockVxForDividend, .dexCancelStakeById, .dexSwitchConfig:
                return ViteWalletConst.ContractAddress.dexFund.address
            case .dexCancelOrder:
                return ViteWalletConst.ContractAddress.dexTrade.address
            }
        }

        fileprivate static let toAddressAndDataPrefixMap: [String: BuildIn] =
            BuildIn.allCases.reduce([String: BuildIn]()) { (r, t) -> [String: BuildIn] in
                var ret = r
                let key = "\(t.toAddress).\(t.encodedFunctionSignature.toHexString())"
                ret[key] = t
                return ret
        }

        public static func type(data: Data?, toAddress: ViteAddress) -> (BuildIn, [ABIParameterValue])? {
            if let data = data, data.count >= 4,
                let type = toAddressAndDataPrefixMap["\(toAddress).\(data[0..<4].toHexString())"] {
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

        public static func getData(type: BuildIn, values: [String]) -> Data {
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


