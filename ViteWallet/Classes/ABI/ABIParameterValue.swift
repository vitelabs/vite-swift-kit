//
//  ABIParameterValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import Vite_HDWalletKit
import BigInt

public class ABIParameterValue {

    public func abiEncode() -> Data? {
        fatalError()
    }

}

/*
// ABIIntegerValue: ABIParameterValue
extension ABIIntegerValue {
    public func abiEncode(type: ABI.ParameterType) -> Data? {
        guard case .static(let type) = type else { return nil }
        switch type {
        case .uint(let bits):
            guard bits <= 256, bits % 8 == 0 else { return nil }
            return toBigUInt()?.abiEncode(bits: 256)
        case .int(let bits):
            guard bits <= 256, bits % 8 == 0 else { return nil }
            return toBigInt()?.abiEncode(bits: 256)
        default:
            return nil
        }
    }
}

extension Bool: ABIParameterValue {
    public func abiEncode(type: ABI.ParameterType) -> Data? {
        guard case .static(let type) = type else { return nil }
        guard case .bool = type else { return nil }
        return Data(repeating: 0, count: 31) + Data(UInt8(self ? 1 : 0).toBytes)
    }
}

extension String: ABIParameterValue {
    public func abiEncode(type: ABI.ParameterType) -> Data? {
        switch type {
        case .static(let type):
            switch type {
            case .tokenId:
                return rawViteTokenId.map { Data(repeating: 0, count: 22) + Data($0) }
            case .address:
                return rawViteAddress.map { Data(repeating: 0, count: 11) + Data($0) }
            case .gid:
                return rawViteGId.map { Data(repeating: 0, count: 22) + Data($0) }
            default:
                return nil
            }
        case .dynamic(let type):
            switch type {
            case .string:
                guard let data = self.data(using: .utf8) else { return nil }
                return data.alignTo32Bytes()
            default:
                return nil
            }
        }
    }
}
*/
