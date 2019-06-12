//
//  ABIDecoding.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Vite_HDWalletKit
import BigInt

extension ABI.Decoding {

    public enum DecodingError: Error {
        case invalidABIString
        case conversionFailed
        case signatureNotMatch
    }

    static func decodeParameter(_ data: Data, type: ABI.ParameterType) throws -> ABIParameterValue {
        guard let value = type.valueType.init(from: data, type: type) else {
            throw DecodingError.conversionFailed
        }
        return value
    }

    static func lengthABIDecode(data: Data) -> UInt64? {
        guard data.count == 32 else { return nil }
        let bigUInt = BigUInt(data)
        return UInt64(bigUInt)
    }

    static func indexABIDecode(data: Data) -> UInt64? {
        guard data.count == 32 else { return nil }
        let bigUInt = BigUInt(data)
        return UInt64(bigUInt)
    }

    static func decodeParameters(_ data: Data, types: [ABI.ParameterType]) throws -> [ABIParameterValue] {
        var offset: UInt64 = 0
        var array = [ABIParameterValue]()
        for type in types {
            let range = offset ..< (offset + type.staticSize)
            if type.isStatic {
                let slice = Data(data[range])
                let value = try decodeParameter(slice, type: type)
                array.append(value)
            } else {
                let indexData = Data(data[range])
                guard let index = indexABIDecode(data: indexData) else {
                    throw DecodingError.conversionFailed
                }
                let slice = Data(data[index...])
                let value = try decodeParameter(slice, type: type)
                array.append(value)
            }
            offset += type.staticSize
        }
        return array
    }

    public static func decodeParameters(_ data: Data, abiString: String) throws -> [ABIParameterValue] {
        guard let abiRecord = ABI.Record.tryToConvertToFunctionRecord(abiString: abiString) else {
            throw DecodingError.invalidABIString
        }

        let name = abiRecord.name!
        let types = try (abiRecord.inputs ?? []).map { try ABI.Parsing.parseToType(from: $0.type) }

        var signature = name
        signature.append("(")
        for type in types {
            signature.append(type.toString())
            signature.append(",")
        }
        if signature.hasSuffix(",") {
            signature.removeLast()
        }
        signature.append(")")

        let signatureData = try ABI.Encoding.encodeFunctionSignature(signature)
        guard signatureData == data[0 ..< 4] else {
            throw DecodingError.signatureNotMatch
        }

        return try decodeParameters(Data(data[4...]), types: types)
    }
}
