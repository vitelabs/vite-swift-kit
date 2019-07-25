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
        case invalidABIString
        case conversionFailed
        case invalidParameter
        case invalidValue(value: Any, type: ABI.ParameterType)
    }

    public static func encodeLogSignature(signature: String) throws -> Data {
        return try encodeFunction(signature: signature)
    }

    public static func encodeFunctionSignature(abiString: String) throws -> Data {
        let (signature, _) = try abi2SignatureAndTypes(abiString: abiString)
        return try encodeFunctionSignature(signature: signature)
    }

    public static func encodeFunctionSignature(signature: String) throws -> Data {
        let data = try encodeFunction(signature: signature)
        return Data(data[..<4])
    }

    private static func encodeFunctionCall(signature: String, values: [Any], types: [ABI.ParameterType]) throws -> Data {
        return try encodeFunctionSignature(signature: signature) + encodeParameters(values, types: types)
    }

    public static func encodeFunctionCall(abiString: String, valuesString: String) throws -> Data {
        guard let valuesData = valuesString.data(using: .utf8),
            let j = try? JSONSerialization.jsonObject(with: valuesData, options: .mutableContainers),
            let values = j as? [Any] else {
                throw EncodingError.invalidABIString
        }

        let (signature, types) = try abi2SignatureAndTypes(abiString: abiString)
        return try encodeFunctionCall(signature: signature, values: values, types: types)
    }

    public static func abi2SignatureAndTypes(abiString: String) throws -> (String, [ABI.ParameterType]) {
        guard let abiRecord = ABI.Record.tryToConvertToFunctionRecord(abiString: abiString) else {
            throw EncodingError.invalidABIString
        }

        let types = try (abiRecord.inputs ?? []).map { try ABI.Parsing.parseToType(from: $0.type) }

        var signature = abiRecord.name ?? ""
        signature.append("(")
        for type in types {
            signature.append(type.toString())
            signature.append(",")
        }
        if signature.hasSuffix(",") {
            signature.removeLast()
        }
        signature.append(")")
        return (signature, types)
    }
}

extension ABI.Encoding {

    static func lengthABIEncode(length: UInt64) -> Data? {
        return BigUInt(length).abiEncode(bits: 256)
    }

    static func indexABIEncode(length: UInt64) -> Data? {
        return BigUInt(length).abiEncode(bits: 256)
    }

    static func encodeFunction(signature: String) throws -> Data {
        guard let data = signature.data(using: .utf8),
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
