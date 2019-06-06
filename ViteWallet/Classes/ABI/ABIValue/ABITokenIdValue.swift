//
//  ABITokenIdValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt

public class ABITokenIdValue: ABIParameterValue {

    private let tokenId: ViteTokenId

    public init?(_ value: Any) {
        switch value {
        case let v as String:
            guard v.isViteTokenId else { return nil }
            tokenId = v
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        guard let bytes = tokenId.rawViteTokenId else { return nil }
        return Data(bytes).setLengthLeft(32)
    }
}
