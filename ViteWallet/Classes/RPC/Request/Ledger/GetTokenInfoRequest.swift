//
//  GetTokenInfoRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetTokenInfoRequest: JSONRPCKit.Request {
    public typealias Response = Token

    let tokenId: String

    public var method: String {
        return "ledger_getTokenMintage"
    }

    public var parameters: Any? {
        return [tokenId]
    }

    public init(tokenId: String) {
        self.tokenId = tokenId
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any] {
            if let ret = Token(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else if resultObject is NSNull {
            throw Wallet.WalletError.invalidTokenId
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
