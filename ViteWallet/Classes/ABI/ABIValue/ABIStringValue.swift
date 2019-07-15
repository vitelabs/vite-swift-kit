//
//  ABIStringValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABIStringValue {

    private let string: String
    private init(string: String) {
        self.string = string
    }
}

extension ABIStringValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .string = type else { return nil }
        guard data.count > 32, data.count % 32 == 0 else { return nil }
        let head = Data(data[0..<32])
        let length = BigUInt(head)
        let size = Int(((length + 31)/32)*32)
        guard length <= data.count - 32 else { return nil }
        guard let raw = Data(data[32..<32+size]).stripPadding(rawLength: UInt64(length), isLeftPadding: false) else { return nil }
        guard let string = String(data: raw, encoding: .utf8) else { return nil }
        self.init(string: string)
    }

    public func toString() -> String {
        return string
    }
}

extension ABIStringValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .string = type else { return nil }
        switch value {
        case let v as String:
            self.init(string: v)
        default:
            return nil
        }
    }

    public func abiEncode() -> Data? {
        guard let data = string.data(using: .utf8) else { return nil }
        return data.alignTo32Bytes()
    }
}
