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

    private static let viteAddressPrefix = "vite_"

    private static func userViteAddressChecksum(_ bytes: Bytes) -> Bytes? {
        return Blake2b.hash(outLength: 5, in: bytes)
    }

    private static func contractViteAddressChecksum(_ bytes: Bytes) -> Bytes? {
        return userViteAddressChecksum(bytes).map { ret in
            ret.map { $0^0xff }
        }
    }

    public static func generateViteAddress(from data: Data) -> ViteAddress? {
        guard data.count == 21 else { return nil }
        let mid = data.dropLast().toHexString()

        if data[20] == 0x00 {
            guard let checksum = ViteAddress.userViteAddressChecksum(Bytes(data.dropLast())) else { return nil }
            return ViteAddress.viteAddressPrefix + mid + checksum.toHexString()
        } else if data[20] == 0x01 {
            guard let checksum = ViteAddress.contractViteAddressChecksum(Bytes(data.dropLast())) else { return nil }
            return ViteAddress.viteAddressPrefix + mid + checksum.toHexString()
        } else {
            return nil
        }

        return nil
    }

    public var viteAddressType: ViteAddressType? {
        guard self.count == 55 else { return nil }
        let prefix = (self as NSString).substring(to: 5) as String
        let hash = (self as NSString).substring(with: NSRange(location: 5, length: 40)) as String
        let suffix = (self as NSString).substring(from: 45) as String
        guard prefix == ViteAddress.viteAddressPrefix else { return nil }
        guard let userChecksum = ViteAddress.userViteAddressChecksum(hash.hex2Bytes) else { return nil }
        guard let contractChecksum = ViteAddress.contractViteAddressChecksum(hash.hex2Bytes) else { return nil }

        if suffix == userChecksum.toHexString() {
            return .user
        } else if suffix == contractChecksum.toHexString() {
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
