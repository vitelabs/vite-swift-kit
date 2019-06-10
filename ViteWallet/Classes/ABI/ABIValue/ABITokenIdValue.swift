//
//  ABITokenIdValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABITokenIdValue {

    private let tokenId: ViteTokenId
    private init(tokenId: ViteTokenId) {
        self.tokenId = tokenId
    }
}

extension ABITokenIdValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .tokenId = type else { return nil }
        guard data.count == 32 else { return nil }
        guard let raw = data.stripPadding(rawLength: 10, isLeftPadding: true) else { return nil }
        guard let tokenId = ViteTokenId.generateViteTokenId(from: raw) else { return nil }
        self.init(tokenId: tokenId)
    }

    public func toString() -> String {
        return tokenId
    }
}

extension ABITokenIdValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .tokenId = type else { return nil }
        switch value {
        case let v as String:
            guard v.isViteTokenId else { return nil }
            self.init(tokenId: v)
        default:
            return nil
        }
    }

    public func abiEncode() -> Data? {
        guard let bytes = tokenId.rawViteTokenId else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
