//
//  SendRawTxRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct SendRawTxRequest: JSONRPCKit.Request {
    public typealias Response = NSNull

    let accountBlock: AccountBlock

    public var method: String {
        return "tx_sendRawTx"
    }

    public var parameters: Any? {
        return [accountBlock.toJSON()]
    }

    public init(accountBlock: AccountBlock) {
        self.accountBlock = accountBlock
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
