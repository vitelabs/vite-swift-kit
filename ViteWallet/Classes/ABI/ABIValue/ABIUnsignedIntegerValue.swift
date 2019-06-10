//
//  ABIUnsignedIntegerValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/4.
//

import Vite_HDWalletKit
import BigInt

public struct ABIUnsignedIntegerValue {

    private let bigUInt: BigUInt
    private init(bigUInt: BigUInt) {
        self.bigUInt = bigUInt
    }
}

extension ABIUnsignedIntegerValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard case .uint(let bits) = type else { return nil }
        guard data.count == 32 else { return nil }
        let mod = BigUInt(1) << (bits ?? 256)
        let bigUInt = BigUInt(data) % mod
        self.init(bigUInt: bigUInt)
    }

    public func toString() -> String {
        return bigUInt.description
    }
}

extension ABIUnsignedIntegerValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard case .uint = type else { return nil }

        let bigUInt: BigUInt
        switch value {
        case let v as String:
            guard let num = BigUInt(v, radix: 10) else { return nil }
            bigUInt = num
        case let v as BigUInt:
            bigUInt = v
        case let v as BigInt:
            guard case .plus = v.sign else { return nil }
            bigUInt = v.magnitude
        case let v as UInt:
            bigUInt = BigUInt(v)
        case let v as UInt8:
            bigUInt = BigUInt(v)
        case let v as UInt16:
            bigUInt = BigUInt(v)
        case let v as UInt32:
            bigUInt = BigUInt(v)
        case let v as UInt64:
            bigUInt = BigUInt(v)
        case let v as Int:
            bigUInt = BigUInt(v)
        case let v as Int8:
            bigUInt = BigUInt(v)
        case let v as Int16:
            bigUInt = BigUInt(v)
        case let v as Int32:
            bigUInt = BigUInt(v)
        case let v as Int64:
            bigUInt = BigUInt(v)
        default:
            return nil
        }

        self.init(bigUInt: bigUInt)
    }

    public func abiEncode() -> Data? {
        return bigUInt.abiEncode(bits: 256)
    }
}
