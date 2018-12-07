//
//  AccountBlock.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import BigInt
import CryptoSwift
import Vite_HDWalletKit

struct AccountBlock: Mappable {

    struct Const {
        static let defaultHash = "0000000000000000000000000000000000000000000000000000000000000000"

        enum Difficulty {
            case sendWithoutData
            case receive
            case pledge
            case vote
            case cancelVote

            var value: BigInt {
                switch self {
                case .sendWithoutData:
                    return BigInt("157108864")!
                case .receive, .pledge:
                    return BigInt("67108864")!
                case .vote, .cancelVote:
                    return BigInt("201564160")!
                }

            }
        }
    }

    enum BlockType: Int {
        case createSend = 1
        case send = 2
        case rewardSend = 3
        case receive = 4
        case receiveError = 5
    }

    fileprivate(set) var type: BlockType?
    fileprivate(set) var hash: String?
    fileprivate(set) var prevHash: String?
    fileprivate(set) var accountAddress: Address?
    fileprivate(set) var publicKey: String?
    fileprivate(set) var fromAddress: Address?
    fileprivate(set) var toAddress: Address?
    fileprivate(set) var fromHash: String?
    fileprivate(set) var tokenId: String?
    fileprivate(set) var snapshotHash: String?
    fileprivate(set) var data: String?
    fileprivate(set) var timestamp: Int64?
    fileprivate(set) var logHash: String?
    fileprivate(set) var nonce: String?
    fileprivate(set) var difficulty: BigInt?
    fileprivate(set) var signature: String?
    fileprivate(set) var height: UInt64?
    fileprivate(set) var quota: UInt64?
    fileprivate(set) var amount: BigInt?
    fileprivate(set) var fee: BigInt?
    fileprivate(set) var confirmedTimes: UInt64?
    fileprivate(set) var tokenInfo: Token?

    init() {

    }

    init?(map: Map) {
        guard let type = map.JSON["blockType"] as? Int, let _ = BlockType(rawValue: type) else {
            return nil
        }
    }

    init(address: Address) {
        self.init()
        self.accountAddress = address
    }

    mutating func mapping(map: Map) {
        type <- map["blockType"]
        hash <- map["hash"]
        prevHash <- map["prevHash"]
        accountAddress <- (map["accountAddress"], JSONTransformer.address)
        publicKey <- (map["publicKey"], JSONTransformer.hexTobase64)
        fromAddress <- (map["fromAddress"], JSONTransformer.address)
        toAddress <- (map["toAddress"], JSONTransformer.address)
        fromHash <- map["fromBlockHash"]
        tokenId <- map["tokenId"]
        snapshotHash <- map["snapshotHash"]
        data <- map["data"]
        timestamp <- map["timestamp"]
        logHash <- map["logHash"]
        nonce <- (map["nonce"], JSONTransformer.hexTobase64)
        difficulty <- (map["difficulty"], JSONTransformer.bigint)
        signature <- (map["signature"], JSONTransformer.hexTobase64)
        height <- (map["height"], JSONTransformer.uint64)
        quota <- (map["quota"], JSONTransformer.uint64)
        amount <- (map["amount"], JSONTransformer.bigint)
        fee <- (map["fee"], JSONTransformer.bigint)
        confirmedTimes <- (map["confirmedTimes"], JSONTransformer.uint64)
        tokenInfo <- map["tokenInfo"]
    }
}

extension AccountBlock {

    static func makeSendAccountBlock(secretKey: String,
                                     publicKey: String,
                                     address: Address,
                                     latest: AccountBlock,
                                     snapshotHash: String,
                                     toAddress: Address,
                                     tokenId: String,
                                     amount: BigInt,
                                     data: String?,
                                     nonce: String?,
                                     difficulty: BigInt?) -> AccountBlock {

        var block = makeBaseAccountBlock(secretKey: secretKey,
                                         publicKey: publicKey,
                                         address: address,
                                         latest: latest,
                                         snapshotHash: snapshotHash,
                                         nonce: nonce,
                                         difficulty: difficulty)

        block.type = .send
        block.toAddress = toAddress
        block.amount = amount
        block.tokenId = tokenId
        block.data = data

        let (hash, signature) = sign(accountBlock: block,
                                     secretKeyHexString: secretKey,
                                     publicKeyHexString: publicKey)
        block.hash = hash
        block.signature = signature

        return block
    }

    static func makeReceiveAccountBlock(secretKey: String,
                                        publicKey: String,
                                        address: Address,
                                        unconfirmed: AccountBlock,
                                        latest: AccountBlock,
                                        snapshotHash: String,
                                        nonce: String?,
                                        difficulty: BigInt?) -> AccountBlock {

        var block = makeBaseAccountBlock(secretKey: secretKey,
                                         publicKey: publicKey,
                                         address: address,
                                         latest: latest,
                                         snapshotHash: snapshotHash,
                                         nonce: nonce,
                                         difficulty: difficulty)

        block.type = .receive
        block.fromHash = unconfirmed.hash

        let (hash, signature) = sign(accountBlock: block,
                                     secretKeyHexString: secretKey,
                                     publicKeyHexString: publicKey)
        block.hash = hash
        block.signature = signature

        return block
    }

    fileprivate static func makeBaseAccountBlock(secretKey: String,
                                                 publicKey: String,
                                                 address: Address,
                                                 latest: AccountBlock,
                                                 snapshotHash: String,
                                                 nonce: String?,
                                                 difficulty: BigInt?) -> AccountBlock {
        var block = AccountBlock()
        block.prevHash = latest.hash ?? Const.defaultHash

        if let height = latest.height {
            block.height = height + 1
        } else {
            block.height = 1
        }

        block.accountAddress = address

        block.fee = BigInt(0)
        block.snapshotHash = snapshotHash
        block.timestamp = Int64(Date().timeIntervalSince1970)
        block.logHash = nil
        block.nonce = nonce
        block.difficulty = difficulty
        block.publicKey = publicKey

        return block
    }

    private static func sign(accountBlock: AccountBlock,
                             secretKeyHexString: String,
                             publicKeyHexString: String) -> (hash: String, signature: String) {
        var source = Bytes()

        if let type = accountBlock.type {
            let bytes = type.rawValue.toBytes
            source.append(contentsOf: [bytes.last!])
        }

        if let prevHash = accountBlock.prevHash {
            source.append(contentsOf: prevHash.hex2Bytes)
        }

        if let height = accountBlock.height {
            source.append(contentsOf: height.toBytes)
        }

        if let accountAddress = accountBlock.accountAddress {
            source.append(contentsOf: accountAddress.raw.hex2Bytes)
        }

        if let type = accountBlock.type {
            switch type {
            case .send:
                if let toAddress = accountBlock.toAddress {
                    source.append(contentsOf: toAddress.raw.hex2Bytes)
                }

                if let amount = accountBlock.amount {
                    source.append(contentsOf: [UInt8](BigUInt(amount).serialize()))
                }

                if let tokenId = accountBlock.tokenId {
                    source.append(contentsOf: Token.idStriped(tokenId).hex2Bytes)
                }
            case .receive:
                if let fromHash = accountBlock.fromHash {
                    source.append(contentsOf: fromHash.hex2Bytes)
                }
            default:
                break
            }
        }

        if let fee = accountBlock.fee {
            source.append(contentsOf: [UInt8](BigUInt(fee).serialize()))
        }

        if let snapshotHash = accountBlock.snapshotHash {
            source.append(contentsOf: snapshotHash.hex2Bytes)
        }

        if let data = accountBlock.data, let ret = Data(base64Encoded: data) {
            source.append(contentsOf: ret)
        }

        if let timestamp = accountBlock.timestamp {
            source.append(contentsOf: timestamp.toBytes)
        }

        if let logHash = accountBlock.logHash {
            source.append(contentsOf: logHash.hex2Bytes)
        }

        if let nonce = accountBlock.nonce {
            source.append(contentsOf: nonce.hex2Bytes)
        }

        let hash = Blake2b.hash(outLength: 32, in: source) ?? Bytes()
        let hashString = hash.toHexString()
        let signature = Ed25519.sign(message: hash, secretKey: secretKeyHexString.hex2Bytes, publicKey: publicKeyHexString.hex2Bytes).toHexString()
        return (hashString, signature)
    }
}

extension FixedWidthInteger {
    var toBytes: [UInt8] {
        var bigEndian = self.bigEndian
        let data = Data(bytes: &bigEndian, count: MemoryLayout.size(ofValue: bigEndian))
        let bytes = [UInt8](data)
        return bytes
    }
}
