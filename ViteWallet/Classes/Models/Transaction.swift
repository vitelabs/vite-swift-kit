//
//  Transaction.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt

struct Transaction: Equatable, Mappable {

    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.hash == rhs.hash
    }

    enum TransactionType: Int {
        case register
        case registerUpdate
        case cancelRegister
        case extractReward
        case vote
        case cancelVote
        case pledge
        case cancelPledge
        case coin
        case cancelCoin
        case send
        case receive
    }

    fileprivate var blockType: AccountBlock.BlockType?
    fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    fileprivate(set) var fromAddress = Address()
    fileprivate(set) var toAddress = Address()
    fileprivate(set) var hash = ""
    fileprivate(set) var amount = Balance()
    fileprivate(set) var token = Token()
    fileprivate(set) var data: String?

    fileprivate static let transactionTypeDataPrefixMap: [String: TransactionType] = [
        "f29c6ce2": .register,
        "3b7bdf74": .registerUpdate,
        "60862fe2": .cancelRegister,
        "ce1f27a7": .extractReward,
        "fdc17f25": .vote,
        "a629c531": .cancelVote,
        "8de7dcfd": .pledge,
        "9ff9c7b6": .cancelPledge,
        "46d0ce8b": .coin,
        "9b9125f5": .cancelCoin,
        ]

    struct Const {
        enum ContractAddress: String {
            case register = "vite_0000000000000000000000000000000000000001c9e9f25417"
            case vote = "vite_000000000000000000000000000000000000000270a48cc491"
            case pledge = "vite_000000000000000000000000000000000000000309508ba646"
            case consensus = "vite_00000000000000000000000000000000000000042d7ef71894"
            case coin = "vite_00000000000000000000000000000000000000056ad6d26692"

            var address: Address {
                return Address(string: self.rawValue)
            }
        }

        static let gid = "00000000000000000001"
    }

    fileprivate static let transactionTypeToAddressMap: [TransactionType: String] = [
        .register: Const.ContractAddress.register.rawValue,
        .registerUpdate: Const.ContractAddress.register.rawValue,
        .cancelRegister: Const.ContractAddress.register.rawValue,
        .extractReward: Const.ContractAddress.register.rawValue,
        .vote: Const.ContractAddress.vote.rawValue,
        .cancelVote: Const.ContractAddress.vote.rawValue,
        .pledge: Const.ContractAddress.pledge.rawValue,
        .cancelPledge: Const.ContractAddress.pledge.rawValue,
        .coin: Const.ContractAddress.coin.rawValue,
        .cancelCoin: Const.ContractAddress.coin.rawValue,
        ]

    var type: TransactionType {
        guard let blockType = blockType else {
            return .receive
        }

        switch blockType {
        case .createSend, .rewardSend:
            return .send
        case .receiveError:
            return .receive
        case .send:
            guard let base64 = data, let string = Data(base64Encoded: base64)?.toHexString() else { return .send }
            guard string.count >= 8 else { return .send }
            let prefix = (string as NSString).substring(to: 8) as String
            if let type = Transaction.transactionTypeDataPrefixMap[prefix] {
                if Transaction.transactionTypeToAddressMap[type] == toAddress.description {
                    return type
                } else {
                    return .send
                }
            } else {
                return .send
            }
        case .receive:
            return .receive
        }
    }

    init?(map: Map) {
        guard let type = map.JSON["blockType"] as? Int, let _ = AccountBlock.BlockType(rawValue: type) else {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        blockType <- map["blockType"]
        timestamp <- (map["timestamp"], JSONTransformer.timestamp)
        fromAddress <- (map["fromAddress"], JSONTransformer.address)
        toAddress <- (map["toAddress"], JSONTransformer.address)
        hash <- map["hash"]
        amount <- (map["amount"], JSONTransformer.balance)
        token <- map["tokenInfo"]
        data <- map["data"]
    }
}
