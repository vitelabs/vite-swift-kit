//
//  ABI.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Vite_HDWalletKit
import BigInt

public struct ABI {

    public enum ParameterType {
        case uint(bits: UInt64?)     // 0 < bits <= 256，bits % 8 == 0
        case int(bits: UInt64?)      // 0 < bits <= 256，bits % 8 == 0
        case bytes(length: UInt64)   // 0 < length <= 32
        case bool
        case tokenId
        case address
        case gid
        case string
        case dynamicBytes
        indirect case array(subType: ParameterType, length: UInt64)  // 0 < length
        indirect case dynamicArray(subType: ParameterType)

        public func toString() -> String {
            switch self {
            case .uint(let bits):
                if let bits = bits {
                    return "uint\(bits)"
                } else {
                    return "uint"
                }
            case .int(let bits):
                if let bits = bits {
                    return "int\(bits)"
                } else {
                    return "int"
                }
            case .bytes(let length):
                return "bytes\(length)"
            case .bool:
                return "bool"
            case .tokenId:
                return "tokenId"
            case .address:
                return "address"
            case .gid:
                return "gid"
            case .string:
                return "string"
            case .dynamicBytes:
                return "bytes"
            case .array(let subType, let length):
                return "\(subType.toString())[\(length)]"
            case .dynamicArray(let subType):
                return "\(subType.toString())[]"
            }
        }

        public var valueType: ABIParameterValue.Type {
            switch self {
            case .uint:
                return ABIUnsignedIntegerValue.self
            case .int:
                return ABISignedIntegerValue.self
            case .bytes:
                return ABIBytesValue.self
            case .bool:
                return ABIBoolValue.self
            case .tokenId:
                return ABITokenIdValue.self
            case .address:
                return ABIAddressValue.self
            case .gid:
                return ABIGIdValue.self
            case .string:
                return ABIStringValue.self
            case .dynamicBytes:
                return ABIBytesValue.self
            case .array:
                return ABIArrayValue.self
            case .dynamicArray:
                return ABIArrayValue.self
            }
        }

        public func convertToABIParameterValue(from value: Any) -> ABIParameterValue? {
            return valueType.init(from: value, type: self)
        }

        public var canBeUsedAsSubType: Bool {
            switch self {
            case .uint, .int, .bytes, .bool, .tokenId, .address, .gid:
                return true
            case .string, .dynamicBytes, .array, .dynamicArray:
                return false
            }
        }

        public var isStatic: Bool {
            switch self {
            case .uint, .int, .bytes, .bool, .tokenId, .address, .gid, .array:
                return true
            case .string, .dynamicBytes, .dynamicArray:
                return false
            }
        }

        public var isArray: Bool {
            switch self {
            case .uint, .int, .bytes, .bool, .tokenId, .address, .gid, .string, .dynamicBytes:
                return false
            case .array, .dynamicArray:
                return true
            }
        }

        public var staticSize: UInt64 {
            switch self {
            case .uint, .int, .bytes, .bool, .tokenId, .address, .gid:
                return UInt64(32)                   // raw data
            case .array(let subType, let length):
                return UInt64(32) * length          // raw data
            case .string, .dynamicBytes, .dynamicArray:
                return UInt64(32)                   // index
            }
        }
    }

    enum Element {
        case function(Function)
    }

    public struct InOut {
        public let name: String
        public let type: ParameterType

        public init(name: String, type: ParameterType) {
            self.name = name
            self.type = type
        }
    }

    public struct Function {
        public let name: String
        public let inputs: [InOut]
        public let outputs: [InOut]

        public init(name: String, inputs: [InOut], outputs: [InOut]) {
            self.name = name
            self.inputs = inputs
            self.outputs = outputs
        }
    }
}

extension ABI {
    public struct Parsing {}
    public struct Encoding {}
    public struct Decoding {}
}

extension ABI {
    struct Input: Decodable {
        public var name: String?
        public var type: String
        public var indexed: Bool?
        public var components: [Input]?
    }

    struct Output: Decodable {
        public var name: String?
        public var type: String
        public var components: [Output]?
    }

    struct Record: Decodable {

        enum RecordType: String, Decodable {
            case function
        }

        public var name: String?
        public var type: RecordType?
        public var inputs: [ABI.Input]?
        public var outputs: [ABI.Output]?

        init?(abiString: String) {
            guard let jsonData = abiString.data(using: .utf8) else { return nil }
            guard let record = try? JSONDecoder().decode(ABI.Record.self, from: jsonData) else { return nil }
            self = record
        }

        static func tryToConvertToFunctionRecord(abiString: String) -> Record? {
            guard let record = Record(abiString: abiString) else { return nil }
            guard let type = record.type, case .function = type else {  return nil }
            guard record.name != nil else { return nil }
            return record
        }
    }
}
