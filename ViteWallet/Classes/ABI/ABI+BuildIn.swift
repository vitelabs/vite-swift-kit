//
//  ABI+Extension.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import BigInt

public extension ABI {

    public enum BuildIn {

        case register
        case registerUpdate
        case cancelRegister
        case extractReward

        case vote
        case cancelVote
        case pledge
        case cancelPledge
        case coin
//        case cancelCoin


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
                return try ABI.Encoding.encodeFunctionCall(abiString: type.abi, valuesString: valuesString)
            } catch {
                return Data()
            }
        }

        public var abi: String {
            switch self {
            case .register:
                return "{\"type\":\"function\",\"name\":\"Register\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
            case .registerUpdate:
                return "{\"type\":\"function\",\"name\":\"UpdateRegistration\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"Name\":\"name\",\"type\":\"string\"},{\"name\":\"nodeAddr\",\"type\":\"address\"}]}"
            case .cancelRegister:
                return  "{\"type\":\"function\",\"name\":\"CancelRegister\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"}]}"
            case .extractReward:
                return "{\"type\":\"function\",\"name\":\"Reward\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"beneficialAddr\",\"type\":\"address\"}]}"
            case .vote:
                return "{\"type\":\"function\",\"name\":\"Vote\", \"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"},{\"name\":\"nodeName\",\"type\":\"string\"}]}"
            case .cancelVote:
                return "{\"type\":\"function\",\"name\":\"CancelVote\",\"inputs\":[{\"name\":\"gid\",\"type\":\"gid\"}]}"
            case .pledge:
                return "{\"type\":\"function\",\"name\":\"Pledge\", \"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"}]}"
            case .cancelPledge:
                return "{\"type\":\"function\",\"name\":\"CancelPledge\",\"inputs\":[{\"name\":\"beneficial\",\"type\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\"}]}"
            case .coin:
                return "{\"type\":\"function\",\"name\":\"Mint\",\"inputs\":[{\"name\":\"isReIssuable\",\"type\":\"bool\"},{\"name\":\"tokenName\",\"type\":\"string\"},{\"name\":\"tokenSymbol\",\"type\":\"string\"},{\"name\":\"totalSupply\",\"type\":\"uint256\"},{\"name\":\"decimals\",\"type\":\"uint8\"},{\"name\":\"maxSupply\",\"type\":\"uint256\"},{\"name\":\"ownerBurnOnly\",\"type\":\"bool\"}]}"
            }
        }
    }
}



