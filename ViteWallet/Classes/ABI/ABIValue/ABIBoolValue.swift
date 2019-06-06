//
//  ABIBoolValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABIBoolValue: ABIParameterValue {

    private let bool: Bool

    public init?(_ value: Any) {
        switch value {
        case let v as Bool:
            bool = v
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        return Data(UInt8(bool ? 1 : 0).toBytes).setLengthLeft(32)
    }
}
