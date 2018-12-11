//
//  Transaction.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Transaction: Equatable, Mappable {

    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.hash == rhs.hash
    }

    public enum TransactionType: Int {
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

    public fileprivate(set) var blockType: AccountBlock.BlockType?
    public fileprivate(set) var timestamp = Date(timeIntervalSince1970: 0)
    public fileprivate(set) var fromAddress = Address()
    public fileprivate(set) var toAddress = Address()
    public fileprivate(set) var hash = ""
    public fileprivate(set) var amount = Balance()
    public fileprivate(set) var token = Token()
    public fileprivate(set) var data: String?

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

    fileprivate static let transactionTypeToAddressMap: [TransactionType: String] = [
        .register: ViteWalletConst.ContractAddress.register.rawValue,
        .registerUpdate: ViteWalletConst.ContractAddress.register.rawValue,
        .cancelRegister: ViteWalletConst.ContractAddress.register.rawValue,
        .extractReward: ViteWalletConst.ContractAddress.register.rawValue,
        .vote: ViteWalletConst.ContractAddress.vote.rawValue,
        .cancelVote: ViteWalletConst.ContractAddress.vote.rawValue,
        .pledge: ViteWalletConst.ContractAddress.pledge.rawValue,
        .cancelPledge: ViteWalletConst.ContractAddress.pledge.rawValue,
        .coin: ViteWalletConst.ContractAddress.coin.rawValue,
        .cancelCoin: ViteWalletConst.ContractAddress.coin.rawValue,
        ]

    public var type: TransactionType {
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

    public init?(map: Map) {
        guard let type = map.JSON["blockType"] as? Int, let _ = AccountBlock.BlockType(rawValue: type) else {
            return nil
        }
    }

    public mutating func mapping(map: Map) {
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
