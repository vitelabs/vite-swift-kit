//
//  ABIStringValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABIStringValue: ABIParameterValue {

    private let string: String

    public init?(_ value: Any) {
        switch value {
        case let v as String:
            string = v
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        guard let data = string.data(using: .utf8) else { return nil }
        return data.alignTo32Bytes()
    }
}
