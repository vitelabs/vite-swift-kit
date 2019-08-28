//
//  AccountBlockDataContentType.swift
//  ViteWallet
//
//  Created by Stone on 2019/4/3.
//

import Vite_HDWalletKit

public struct AccountBlockDataFactory {
    public static func generateCustomData(header: UInt16, data: Data) -> Data {
        return Data(header.toBytes) + data
    }
}

public extension Data {

    public func accountBlockDataToUTF8String() -> String? {
        return String(bytes: self, encoding: .utf8)
    }

    public var contentTypeInUInt16: UInt16? {
        guard count >= 2 else { return nil }
        let high = UInt16(self[0])
        let low = UInt16(self[1])
        let num = (high << 8) + low
        return num
    }

    public var rawContent: Data? {
        guard count >= 2 else { return nil }
        return Data(self.dropFirst(2))
    }
}

extension String {
    public func utf8StringToAccountBlockData() -> Data? {
        if isEmpty {
            return nil
        } else {
            return self.data(using: .utf8, allowLossyConversion: true)
        }
    }
}
