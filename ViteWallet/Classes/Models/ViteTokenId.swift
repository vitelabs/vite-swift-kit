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

    private static let ViteTokenIdPrefix = "tti_"

    private static func viteTokenIdChecksum(_ bytes: Bytes) -> Bytes? {
        return Blake2b.hash(outLength: 2, in: bytes)
    }

    public static func generateViteTokenId(from data: Data) -> ViteTokenId? {
        guard data.count == 10 else { return nil }
        guard let checksum = ViteTokenId.viteTokenIdChecksum(Bytes(data)) else { return nil }
        return ViteTokenId.ViteTokenIdPrefix + data.toHexString() + checksum.toHexString()
    }

    public var isViteTokenId: Bool {
        guard self.count == 28 else { return false }
        let prefix = (self as NSString).substring(to: 4) as String
        let hash = (self as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        let checksum = (self as NSString).substring(from: 24) as String
        guard prefix == ViteTokenId.ViteTokenIdPrefix else { return false }
        guard checksum == ViteTokenId.viteTokenIdChecksum(hash.hex2Bytes)?.toHexString() else { return false }
        return true
    }

    public var rawViteTokenId: Bytes? {
        guard isViteTokenId else { return nil }
        let string = (self as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        return string.hex2Bytes
    }
}
