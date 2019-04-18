//
//  ViteAddress.swift
//  Vite
//
//  Created by Stone on 2018/9/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import Vite_HDWalletKit

public typealias ViteAddress = String

public extension ViteAddress {
    public var isViteAddress: Bool {
        guard self.count == 55 else { return false }
        let prefix = (self as NSString).substring(to: 5) as String
        let hash = (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        let checksum = (self as NSString).substring(from: 45) as String
        guard prefix == "vite_" else { return false }
        guard checksum == Blake2b.hash(outLength: 5, in: hash.hex2Bytes)?.toHexString() else { return false }
        return true
    }

    public var rawViteAddress: Bytes? {
        guard isViteAddress else { return nil}
        let string = (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        return string.hex2Bytes
    }
}
