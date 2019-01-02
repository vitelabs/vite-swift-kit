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

public struct AccountBlock: Mappable {

    struct Const {
        static let defaultHash = "0000000000000000000000000000000000000000000000000000000000000000"
    }

    public enum BlockType: Int {
        case createSend = 1
        case send = 2
        case rewardSend = 3
        case receive = 4
        case receiveError = 5
    }

    public fileprivate(set) var type: BlockType?
    public fileprivate(set) var hash: String?
    public fileprivate(set) var prevHash: String?
    public fileprivate(set) var accountAddress: Address?
    public fileprivate(set) var publicKey: String?
    public fileprivate(set) var fromAddress: Address?
    public fileprivate(set) var toAddress: Address?
    public fileprivate(set) var fromHash: String?
    public fileprivate(set) var tokenId: String?
    public fileprivate(set) var snapshotHash: String?
    public fileprivate(set) var data: String?
    public fileprivate(set) var timestamp: Int64?
    public fileprivate(set) var logHash: String?
    public fileprivate(set) var nonce: String?
    public fileprivate(set) var difficulty: BigInt?
    public fileprivate(set) var signature: String?
    public fileprivate(set) var height: UInt64?
    public fileprivate(set) var quota: UInt64?
    public fileprivate(set) var amount: Balance?
    public fileprivate(set) var fee: Balance?
    public fileprivate(set) var confirmedTimes: UInt64?
    public fileprivate(set) var token: Token?

    public init() {

    }

    public init?(map: Map) {
        guard let type = map.JSON["blockType"] as? Int, let _ = BlockType(rawValue: type) else {
            return nil
        }
    }

    public mutating func mapping(map: Map) {
        type <- map["blockType"]
        hash <- map["hash"]
        prevHash <- map["prevHash"]
        accountAddress <- (map["accountAddress"], JSONTransformer.address)
        publicKey <- (map["publicKey"], JSONTransformer.hexToBase64)
        fromAddress <- (map["fromAddress"], JSONTransformer.address)
        toAddress <- (map["toAddress"], JSONTransformer.address)
        fromHash <- map["fromBlockHash"]
        tokenId <- map["tokenId"]
        snapshotHash <- map["snapshotHash"]
        data <- map["data"]
        timestamp <- map["timestamp"]
        logHash <- map["logHash"]
        nonce <- (map["nonce"], JSONTransformer.hexToBase64)
        difficulty <- (map["difficulty"], JSONTransformer.bigint)
        signature <- (map["signature"], JSONTransformer.hexToBase64)
        height <- (map["height"], JSONTransformer.uint64)
        quota <- (map["quota"], JSONTransformer.uint64)
        amount <- (map["amount"], JSONTransformer.balance)
        fee <- (map["fee"], JSONTransformer.balance)
        confirmedTimes <- (map["confirmedTimes"], JSONTransformer.uint64)
        token <- map["tokenInfo"]
    }
}

extension AccountBlock {

    public static func makeSendAccountBlock(secretKey: String,
                                            publicKey: String,
                                            address: Address,
                                            latest: AccountBlock?,
                                            snapshotHash: String,
                                            toAddress: Address,
                                            tokenId: String,
                                            amount: Balance,
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

    public static func makeReceiveAccountBlock(secretKey: String,
                                               publicKey: String,
                                               address: Address,
                                               onroadBlock: AccountBlock,
                                               latest: AccountBlock?,
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
        block.fromHash = onroadBlock.hash

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
                                                 latest: AccountBlock?,
                                                 snapshotHash: String,
                                                 nonce: String?,
                                                 difficulty: BigInt?) -> AccountBlock {
        var block = AccountBlock()
        block.prevHash = latest?.hash ?? Const.defaultHash

        if let height = latest?.height {
            block.height = height + 1
        } else {
            block.height = 1
        }

        block.accountAddress = address

        block.fee = Balance(value: BigInt(0))
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
                    source.append(contentsOf: [UInt8](BigUInt(amount.value).serialize()))
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
            source.append(contentsOf: [UInt8](BigUInt(fee.value).serialize()))
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
    public var toBytes: [UInt8] {
        var bigEndian = self.bigEndian
        let data = Data(bytes: &bigEndian, count: MemoryLayout.size(ofValue: bigEndian))
        let bytes = [UInt8](data)
        return bytes
    }
}
