//
//  RPCServer.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

public final class RPCServer {
    public static let shared = RPCServer(url: URL(string: "https://api.vitewallet.com/ios")!)

    public let rpcURL: URL

    public init(url: URL) {
        rpcURL = url
    }
}
