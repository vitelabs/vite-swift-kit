//
//  RPCRequest.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit
import PromiseKit

public struct RPCRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    let server: RPCServer
    public typealias Response = Batch.Responses

    var timeoutInterval: Double

    public init(
        for server: RPCServer,
        batch: Batch,
        timeoutInterval: Double = 30.0
        ) {
        self.server = server
        self.batch = batch
        self.timeoutInterval = timeoutInterval
    }

    public var baseURL: URL {
        #if DEBUG

        var characterSet = CharacterSet.decimalDigits
        characterSet.insert(charactersIn: ".")
        guard let host = server.rpcURL.host, host.trimmingCharacters(in: characterSet).isEmpty else {
            return server.rpcURL
        }

        var url = server.rpcURL
        if let array = batch.requestObject as? [[String: Any]] {
            array.forEach {
                if let method = $0["method"] as? String {
                    url.appendPathComponent(method)
                }
            }
        } else if let map = batch.requestObject as? [String: Any] {
            if let method = map["method"] as? String {
                url.appendPathComponent(method)
            }
        }
        return url
        #else
        return server.rpcURL
        #endif
    }

    public var method: HTTPMethod {
        return .post
    }

    public var path: String {
        return "/"
    }

    public var parameters: Any? {
        return batch.requestObject
    }

    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}
