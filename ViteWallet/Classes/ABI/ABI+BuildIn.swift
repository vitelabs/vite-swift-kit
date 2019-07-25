//
//  ABI+Extension.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import BigInt

public extension ABI {

    public enum BuildIn: String {

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

        public var encodedFunctionSignature: Data {
            return try! ABI.Encoding.encodeFunctionSignature(abiString: self.rawValue)
        }

        public var toAddress: ViteAddress {
            switch self {
            case .register, .registerUpdate, .cancelRegister, .extractReward, .vote, .cancelVote:
                return ViteWalletConst.ContractAddress.consensus.address
            case .pledge, .cancelPledge:
                return ViteWalletConst.ContractAddress.pledge.address
            case .coinMint, .coinIssue, .coinBurn, .coinTransferOwner, .coinChangeTokenType:
                return ViteWalletConst.ContractAddress.coin.address
                case .dexDeposit, .dexWithdraw, .dexPost,
                     .dexNewInviter, .dexBindInviter,
                     .dexTransferTokenOwner, .dexNewMarket, .dexMarketConfig:
                return ViteWalletConst.ContractAddress.dexFund.address
            case .dexCancel:
                return ViteWalletConst.ContractAddress.dexTrade.address
            }
        }

        public static func getVoteData(gid: ViteGId, name: String) -> Data {
            return getData(type: .vote, values: [gid, name])
        }

        public static func getCancelVoteData(gid: ViteGId) -> Data {
            return getData(type: .cancelVote, values: [gid])
        }

        public static func getPledgeData(beneficialAddress: ViteAddress) -> Data {
            return getData(type: .pledge, values: [beneficialAddress])
        }

        public static func getCancelPledgeData(beneficialAddress: ViteAddress, amount: Amount) -> Data {
            return getData(type: .cancelPledge, values: [beneficialAddress, amount.description])
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



