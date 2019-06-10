//
//  ABIAddressValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABIAddressValue {

    private let address: ViteAddress
    private init(address: ViteAddress) {
        self.address = address
    }
}

extension ABIAddressValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .address = type else { return nil }
        guard data.count == 32 else { return nil }
        guard let raw = data.stripPadding(rawLength: 21, isLeftPadding: true) else { return nil }
        guard let address = ViteAddress.generateViteAddress(from: raw) else { return nil }
        self.init(address: address)
    }

    public func toString() -> String {
        return address
    }
}

extension ABIAddressValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .address = type else { return nil }
        switch value {
        case let v as String:
            guard v.isViteAddress else { return nil }
            self.init(address: v)
        default:
            return nil
        }
    }

    public func abiEncode() -> Data? {
        guard let bytes = address.rawViteAddress else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
