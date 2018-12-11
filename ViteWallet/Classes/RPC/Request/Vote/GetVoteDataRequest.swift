//
//  GetVoteDataRequest.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetVoteDataRequest: JSONRPCKit.Request {
    public typealias Response = String

    let gid: String
    let name: String

    public var method: String {
        return "vote_getVoteData"
    }

    public var parameters: Any? {
        return [gid, name]
    }

    public init(gid: String, name: String) {
        self.gid = gid
        self.name = name
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
