//
//  ABIEncoding.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Vite_HDWalletKit
import BigInt

extension ABI.Encoding {

    public enum EncodingError: Error {
        case conversionFailed
        case invalidParameter
        case invalidValue(value: Any, type: ABI.ParameterType)
    }

    public static func encodeLogSignature(_ name: String) throws -> Data {
        return try ABI.Encoding.encodeFunction(name)
    }

    public static func encodeFunctionSignature(_ name: String) throws -> Data {
        let data = try ABI.Encoding.encodeFunction(name)
        return data[..<4]
    }

    public static func encodeFunctionCall(_ name: String, values: [AnyObject], types: [ABI.ParameterType]) throws -> Data {
        return try encodeFunctionSignature(name) + ABI.Encoding.encodeParameters(values, types: types)
    }
}

extension ABI.Encoding {

    static func lengthABIEncode(length: UInt64) -> Data? {
        return BigUInt(length).abiEncode(bits: 256)
    }

    static func indexABIEncode(length: UInt64) -> Data? {
        return BigUInt(length).abiEncode(bits: 256)
    }

    static func encodeFunction(_ name: String) throws -> Data {
        guard let data = name.data(using: .utf8),
            let hash = Blake2b.hash(outLength: 32, in: Bytes(data)) else {
                throw EncodingError.conversionFailed
        }
        return Data(hash)
    }

    static func encodeParameters(_ values: [Any], types: [ABI.ParameterType]) throws -> Data {
        guard values.count == types.count else {
            throw EncodingError.invalidParameter
        }

        var data = Data()
        var dynamicData = Data()
        let staticSize = types.map { $0.staticSize }.reduce(UInt64(0), +)

        for i in 0..<values.count {
            let value = values[i]
            let type = types[i]

            if type.isStatic {
                data.append(try encodeParameter(value, type: type))
            } else {
                guard let index = indexABIEncode(length: staticSize + UInt64(dynamicData.count)) else { fatalError() }
                data.append(index)
                dynamicData.append(try encodeParameter(value, type: type))
            }
        }

        return data + dynamicData
    }

    static func encodeParameter(_ value: Any, type: ABI.ParameterType) throws -> Data {
        guard let data = type.convertToABIParameterValue(from: value)?.abiEncode() else {
            throw EncodingError.invalidValue(value: value, type: type)
        }
        return data
    }
}
