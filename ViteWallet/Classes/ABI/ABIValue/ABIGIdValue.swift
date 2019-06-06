//
//  ABIGIdValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABIGIdValue: ABIParameterValue {

    private let gid: ViteGId

    public init?(_ value: Any) {
        switch value {
        case let v as String:
            guard v.isViteGId else { return nil }
            gid = v
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        guard let bytes = gid.rawViteGId else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
