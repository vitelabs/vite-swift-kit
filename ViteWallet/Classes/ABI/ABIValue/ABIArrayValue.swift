//
//  ABIArrayValue.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import CryptoSwift
import BigInt


public struct ABIArrayValue {

    private let items: [ABIParameterValue]
    private let subType: ABI.ParameterType
    private let isStatic: Bool
    private init(items: [ABIParameterValue], subType: ABI.ParameterType, isStatic: Bool) {
        self.items = items
        self.subType = subType
        self.isStatic = isStatic
    }

    private static func getSubTypeAndLength(type: ABI.ParameterType) -> (ABI.ParameterType, UInt64?)? {
        let subType: ABI.ParameterType
        let length: UInt64?
        if case .array(let s, let l) = type {
            subType = s
            length = l
        } else if case .dynamicArray(let s) = type {
            subType = s
            length = nil
        } else {
            return nil
        }

        return (subType, length)
    }
}

extension ABIArrayValue: ABIParameterValueDecodable {
    public init?(from data: Data, type: ABI.ParameterType) {
        guard let (subType, l) = ABIArrayValue.getSubTypeAndLength(type: type) else { return nil }
        guard data.count % 32 == 0 else { return nil }

        var items = [ABIParameterValue]()
        if let length = l {
            guard data.count >= length * 32 else { return nil }
            for index in 0..<length {
                let slice = Data(data[(index * 32) ..< ((index + 1) * 32)])
                guard let item = try? ABI.Decoding.decodeParameter(slice, type: subType) else { return nil }
                items.append(item)
            }
        } else {
            guard data.count > 32 else { return nil }
            let head = Data(data[0..<32])
            let length = BigUInt(head)
            guard data.count >= 32 + length * 32 else { return nil }
            for index in 0..<UInt64(length) {
                let slice = Data(data[((index + 1) * 32) ..< ((index + 2) * 32)])
                guard let item = try? ABI.Decoding.decodeParameter(slice, type: subType) else { return nil }
                items.append(item)
            }
        }

        self.init(items: items, subType: subType, isStatic: l != nil)
    }

    public func toString() -> String {
        let array = items.map { $0.toString() }
        let data = try! JSONSerialization.data(withJSONObject: array, options: [])
        let ret = String(data: data, encoding: .utf8)!
        return ret
    }
}

extension ABIArrayValue: ABIParameterValueEncodable {
    public init?(from value: Any, type: ABI.ParameterType) {
        guard let (subType, length) = ABIArrayValue.getSubTypeAndLength(type: type) else { return nil }

        let items: [ABIParameterValue]
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
            items = array
        default:
            return nil
        }

        self.init(items: items, subType: subType, isStatic: length != nil)
    }

    public func abiEncode() -> Data? {
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
