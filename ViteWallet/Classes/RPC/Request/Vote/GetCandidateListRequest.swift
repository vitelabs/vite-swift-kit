//
//  GetVoteInfoRequest.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct GetCandidateListRequest: JSONRPCKit.Request {
    public typealias Response = [Candidate]

    let gid: String

    public var method: String {
        return "register_getCandidateList"
    }

    public var parameters: Any? {
        return [gid]
    }

    public init(gid: String) {
        self.gid = gid
    }

    public func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? [[String: String]] {
            let a = response.map { Candidate(JSON: $0) }
            return a.compactMap({ $0 })
        } else {
            throw ViteError.JSONTypeError
        }
    }
}
