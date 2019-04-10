//
//  GetPowNonceRequest.swift
//  Vite
//
//  Created by Stone on 2018/10/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import BigInt
import JSONRPCKit
import Vite_HDWalletKit

public struct GetPowNonceRequest: JSONRPCKit.Request {
    public typealias Response = String

    let difficulty: BigInt
    let address: Address
    let preHash: String?

    public var method: String {
        return "pow_getPowNonce"
    }

    public var parameters: Any? {
        let preHash = self.preHash ?? AccountBlock.Const.defaultHash
        let text = address.raw + preHash
        let data: String = Blake2b.hash(outLength: 32, in: text.hex2Bytes)?.toHexString() ?? ""
        return [String(difficulty), data]
    }

    public init(address: Address, preHash: String?, difficulty: BigInt) {
        self.address = address
        self.preHash = preHash
        self.difficulty = difficulty
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String, let nonce = Data(base64Encoded: response)?.toHexString() {
            return nonce
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
