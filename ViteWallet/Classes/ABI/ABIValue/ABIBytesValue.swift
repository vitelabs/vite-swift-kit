//
//  ABIBytesValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABIBytesValue {

    private let data: Data
    private let isStatic: Bool

    private init(data: Data, isStatic: Bool) {
        self.data = data
        self.isStatic = isStatic
    }

    private static func getLength(type: ABI.ParameterType) -> (UInt64?)? {
        let length: UInt64?
        if case .bytes(let l) = type {
            length = l
        } else if case .dynamicBytes = type {
            length = nil
        } else {
            return nil
        }

        return (length)
    }
}

extension ABIBytesValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard let (l) = ABIBytesValue.getLength(type: type) else { return nil }
        let raw: Data
        if let length = l {
            guard data.count == 32 else { return nil }
            guard length <= 32 else { return nil }
            guard let r = data.stripPadding(rawLength: length, isLeftPadding: false) else { return nil }
            raw = r
        } else {
            guard data.count > 32, data.count % 32 == 0 else { return nil }
            let head = Data(data[0..<32])
            let length = BigUInt(head)
            let size = Int(((length + 31)/32)*32)
            guard length <= data.count - 32 else { return nil }
            guard let r = Data(data[32..<32+size]).stripPadding(rawLength: UInt64(length), isLeftPadding: false) else { return nil }
            raw = r
        }

        self.init(data: raw, isStatic: l != nil)
    }

    public func toString() -> String {
        return data.toHexString()
    }
}

extension ABIBytesValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard let (length) = ABIBytesValue.getLength(type: type) else { return nil }

        let data: Data
        switch value {
        case let v as String:
            let striped = v.stripHexPrefixIfHas()
            let d = Data(hex: striped)
            guard (striped.count % 2) == 0, (striped.count / 2) == d.count else { return nil }
            data = d
        case let v as Data:
            data = v
        default:
            return nil
        }

        if let l = length {
            guard l == data.count, l <= 32 else { return nil }
        }

        self.init(data: data, isStatic: length != nil)
    }



    public func abiEncode() -> Data? {
        if isStatic {
            return data.setLengthRight(32)
        } else {
            return data.alignTo32Bytes()
        }
    }
}
