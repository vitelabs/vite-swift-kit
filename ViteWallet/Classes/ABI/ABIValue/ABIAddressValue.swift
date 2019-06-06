//
//  ABIAddressValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABIAddressValue: ABIParameterValue {

    private let address: ViteAddress

    public init?(_ value: Any) {
        switch value {
        case let v as String:
            guard v.isViteAddress else { return nil }
            address = v
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        guard let bytes = address.rawViteAddress else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
