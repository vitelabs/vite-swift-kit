//
//  ABIArrayValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt


public class ABIArrayValue: ABIParameterValue {

    private let items: [ABIParameterValue]
    private let subType: ABI.ParameterType
    private let isStatic: Bool

    public init?(_ value: Any, subType: ABI.ParameterType, length: UInt64?) {
        switch value {
        case let v as String:
            guard let data = v.data(using: .utf8),
                let j = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                let json = j as? [Any] else { return nil }

            var array = [ABIParameterValue]()
            for e in json {
                guard let item = subType.convertToABIParameterValue(from: e) else { return nil }
                array.append(item)
            }
            if let l = length {
                guard l == array.count else { return nil }
            }
            self.items = array
            self.subType = subType
            self.isStatic = (length != nil)
        default:
            return nil
        }
    }

    public override func abiEncode() -> Data? {
        let data = items.reduce(Data()) { (ret, item) -> Data in
            ret + (item.abiEncode() ?? Data())
        }
        guard data.count > 0 else { return nil }

        if isStatic {
            return data
        } else {
            guard let head = ABI.Encoding.lengthABIEncode(length: UInt64(data.count / 32)) else { return nil }
            return head + data
        }
    }
}
