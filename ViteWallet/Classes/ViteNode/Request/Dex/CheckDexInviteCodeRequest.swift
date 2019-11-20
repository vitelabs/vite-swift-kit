//
//  CheckDexInviteCodeRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct CheckDexInviteCodeRequest: JSONRPCKit.Request {
    public typealias Response = Bool

    let inviteCode: Int64

    public var method: String {
        return "dex_isInviteCodeValid"
    }

    public var parameters: Any? {
        return [inviteCode]
    }

    public init(inviteCode: Int64) {
        self.inviteCode = inviteCode
    }

    public func response(from resultObject: Any) throws -> Response {

        guard let response = resultObject as? Bool else {
            throw ViteError.JSONTypeError
        }

        return response
    }
}
