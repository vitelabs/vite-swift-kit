//
//  ViteTokenId.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/18.
//

import Foundation
import Vite_HDWalletKit

public typealias ViteTokenId = String

public extension ViteTokenId {

    public var isViteTokenId: Bool {
        guard self.count == 28 else { return false }
        let prefix = (self as NSString).substring(to: 4) as String
        let hash = (self as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        let checksum = (self as NSString).substring(from: 24) as String
        guard prefix == "tti_" else { return false }
        guard checksum == Blake2b.hash(outLength: 2, in: hash.hex2Bytes)?.toHexString() else { return false }
        return true
    }

    public var rawViteTokenId: Bytes? {
        guard isViteTokenId else { return nil }
        let string = (self as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        return string.hex2Bytes
    }
}
