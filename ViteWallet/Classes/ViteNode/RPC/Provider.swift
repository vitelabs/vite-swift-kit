//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import APIKit
import JSONRPCKit
import PromiseKit
import BigInt

public final class Provider {
    public static let `default` = Provider(server: RPCServer.shared)

    public fileprivate(set) var server: RPCServer
    public init(server: RPCServer) {
        self.server = server
    }

    public func update(server: RPCServer) {
        self.server = server
    }
}

extension JSONRPCKit.Request {
    public var defaultProviderPromise: Promise<Response> {
        return RPCRequest(for: Provider.default.server, batch: BatchFactory().create(self)).promise
    }
}

extension APIKit.Request {
    public var promise: Promise<Response> {
        return Promise<Response> { seal in
            Session.send(self) { result in
                switch result {
                case .success(let r):
                    seal.fulfill(r)
                case .failure(let e):
                    seal.reject(e)
                }
            }
        }
    }
}
