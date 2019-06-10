//
//  ABIBoolValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public struct ABIBoolValue {

    private let bool: Bool
    private init(bool: Bool) {
        self.bool = bool
    }
}

extension ABIBoolValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .bool = type else { return nil }
        guard data.count == 32 else { return nil }
        guard let raw = data.stripPadding(rawLength: 1, isLeftPadding: true) else { return nil }
        let bool: Bool
        if raw[0] == 0x00 {
            bool = false
        } else if raw[0] == 0x01 {
            bool = true
        } else {
            return nil
        }
        self.init(bool: bool)
    }

    public func toString() -> String {
        return bool ? "true" : "false"
    }
}

extension ABIBoolValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .bool = type else { return nil }
        switch value {
        case let v as Bool:
            self.init(bool: v)
        case let v as String:
            if v == "1" || v == "true" {
                self.init(bool: true)
            } else if v == "0" || v == "false" {
                self.init(bool: false)
            } else {
                return nil
            }
        default:
            let bigInt: BigInt
            switch value {
            case let v as BigUInt:
                bigInt = BigInt(v)
            case let v as BigInt:
                bigInt = v
            case let v as UInt:
                bigInt = BigInt(v)
            case let v as UInt8:
                bigInt = BigInt(v)
            case let v as UInt16:
                bigInt = BigInt(v)
            case let v as UInt32:
                bigInt = BigInt(v)
            case let v as UInt64:
                bigInt = BigInt(v)
            case let v as Int:
                bigInt = BigInt(v)
            case let v as Int8:
                bigInt = BigInt(v)
            case let v as Int16:
                bigInt = BigInt(v)
            case let v as Int32:
                bigInt = BigInt(v)
            case let v as Int64:
                bigInt = BigInt(v)
            default:
                return nil
            }

            if bigInt == BigInt(1) {
                self.init(bool: true)
            } else if bigInt == BigInt(0) {
                self.init(bool: false)
            } else {
                return nil
            }
        }
    }

    public func abiEncode() -> Data? {
        return Data(UInt8(bool ? 1 : 0).toBytes).setLengthLeft(32)
    }
}
