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

    public enum ViteAddressType {
        case user
        case contract
    }

    public var viteAddressType: ViteAddressType? {
        guard self.count == 55 else { return nil }
        let prefix = (self as NSString).substring(to: 5) as String
        let hash = (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        let suffix = (self as NSString).substring(from: 45) as String
        guard prefix == "vite_" else { return nil }
        guard let checksum = Blake2b.hash(outLength: 5, in: hash.hex2Bytes) else { return nil }
        let reverse = checksum.map { $0^0xff }

        if suffix == checksum.toHexString() {
            return .user
        } else if suffix == reverse.toHexString() {
            return .contract
        } else {
            return nil
        }
    }

    public var isViteAddress: Bool {
        return viteAddressType != nil
    }

    public var rawViteAddress: Bytes? {
        guard let type = viteAddressType else { return nil }
        var string = (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        switch type {
        case .user:
            string.append("00")
        case .contract:
            string.append("01")
        }
        return string.hex2Bytes
    }
}
