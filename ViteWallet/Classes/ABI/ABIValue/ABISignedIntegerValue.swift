//
//  ABISignedIntegerValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/4.
//

import Vite_HDWalletKit
import BigInt

public class ABISignedIntegerValue: ABIParameterValue {

    private let bigInt: BigInt

    public init?(_ value: Any) {
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
    }

    public override func abiEncode() -> Data? {
        return bigInt.abiEncode(bits: 256)
    }
}
