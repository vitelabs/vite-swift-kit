//
//  ABISignedIntegerValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/4.
//

import Vite_HDWalletKit
import BigInt

public struct ABISignedIntegerValue {

    private let bigInt: BigInt
    private init(bigInt: BigInt) {
        self.bigInt = bigInt
    }

    public func toBigInt() -> BigInt {
        return bigInt
    }
}

extension ABISignedIntegerValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .int(let bits) = type else { return nil }
        guard data.count == 32 else { return nil }
        let mod = BigInt(1) << (bits ?? 256)
        let bigInt = BigInt.fromTwosComplement(data: data) % mod
        self.init(bigInt: bigInt)
    }

    public func toString() -> String {
        return bigInt.description
    }
}

extension ABISignedIntegerValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .int = type else { return nil }

        let bigInt: BigInt
        switch value {
        case let v as String:
            guard let num = BigInt(v, radix: 10) else { return nil }
            bigInt = num
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

        self.init(bigInt: bigInt)
    }

    public func abiEncode() -> Data? {
        return bigInt.abiEncode(bits: 256)
    }
}
