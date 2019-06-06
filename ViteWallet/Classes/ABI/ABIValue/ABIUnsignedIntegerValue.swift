//
//  ABIUnsignedIntegerValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/4.
//

import Vite_HDWalletKit
import BigInt

public class ABIUnsignedIntegerValue: ABIParameterValue {

    private let bigUInt: BigUInt

    public init?(_ value: Any) {
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
    }

    public override func abiEncode() -> Data? {
        return bigUInt.abiEncode(bits: 256)
    }
}
