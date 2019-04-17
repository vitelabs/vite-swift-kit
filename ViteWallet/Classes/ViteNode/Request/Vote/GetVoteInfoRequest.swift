//
//  GetVoteInfoRequest.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetVoteInfoRequest: JSONRPCKit.Request {
    public typealias Response = VoteInfo?

    let gid: String
    let address: ViteAddress

    public var method: String {
        return "vote_getVoteInfo"
    }

    public var parameters: Any? {
        return [gid, address]
    }

    public init(gid: String, address: ViteAddress) {
        self.gid = gid
        self.address = address
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [String: Any] {
            if let ret = VoteInfo(JSON: response) {
                return ret
            } else {
                throw ViteError.JSONTypeError
            }
        } else if  let _ = resultObject as? NSNull {
            return nil
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
