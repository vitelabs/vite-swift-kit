//
//  ABIBytesValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABIBytesValue: ABIParameterValue {

    private let data: Data
    private let isStatic: Bool

    public init?(_ value: Any, length: UInt64?) {
        switch value {
        case let v as String:
            let striped = v.stripHexPrefixIfHas()
            let data = Data(hex: striped)
            guard (striped.count % 2) == 0, (striped.count / 2) == data.count else { return nil }
            self.data = data
        case let v as Data:
            self.data = v
        default:
            return nil
        }

        if let l = length {
            guard l == data.count, l <= 32 else { return nil }
        }
        self.isStatic = (length != nil)
    }

    public override func abiEncode() -> Data? {
        if isStatic {
            return data.setLengthRight(32)
        } else {
            return data.alignTo32Bytes()
        }
    }
}
