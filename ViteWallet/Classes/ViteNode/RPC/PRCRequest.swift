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
        #if DEBUG || TEST
        var urlComponents = URLComponents(url: server.rpcURL, resolvingAgainstBaseURL: false)!
        if let array = batch.requestObject as? [[String: Any]] {
            var items = [URLQueryItem]()
            for (index, r) in array.enumerated() {
                if let method = r["method"] as? String {
                    items.append(URLQueryItem(name: "\(index + 1)", value: method))
                }
            }
            urlComponents.queryItems = items
        } else if let map = batch.requestObject as? [String: Any] {
            if let method = map["method"] as? String {
                urlComponents.queryItems = [URLQueryItem(name: "0", value: method)]
            }
        }
        return urlComponents.url!
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
