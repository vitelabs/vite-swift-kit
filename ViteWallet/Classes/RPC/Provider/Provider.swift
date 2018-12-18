//
//  TransactionProvider.swift
//  Vite
//
//  Created by Stone on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

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
