//
//  ABIGIdValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABIGIdValue {

    private let gid: ViteGId
    private init(gid: ViteGId) {
        self.gid = gid
    }
}

extension ABIGIdValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .gid = type else { return nil }
        guard data.count == 32 else { return nil }
        guard let raw = data.stripPadding(rawLength: 10, isLeftPadding: true) else { return nil }
        self.init(gid: raw.toHexString())
    }

    public func toString() -> String {
        return gid
    }
}

extension ABIGIdValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .gid = type else { return nil }
        switch value {
        case let v as String:
            guard v.isViteGId else { return nil }
            self.init(gid: v)
        default:
            return nil
        }
    }

    public func abiEncode() -> Data? {
        guard let bytes = gid.rawViteGId else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
