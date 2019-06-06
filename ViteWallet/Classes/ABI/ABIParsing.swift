//
//  ABI.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Vite_HDWalletKit
import BigInt

extension ABI.Parsing {

    enum ParsingExpressions {
        static var baseTypeRegex = "^((u?int|bytes)([1-9][0-9]*)?|bool|tokenId|address|gid|string)$"
        static var arrayTypeRegex = "^(.*)(\\[(([1-9][0-9]*)?)\\])$"
    }

    public enum ParsingError: Error {
        case invalidString
        case invalidBits
        case invalidLenght
        case subTypeNotSupport(type: ABI.ParameterType)
        case nestArrayUnSupported
    }

    static func parseToType(from string: String) throws -> ABI.ParameterType {

        func match(regex: NSRegularExpression, in string: String, at index: Int) -> [String] {
            var ret: [String] = []
            let array = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
            if let m = array.first {
                let range = m.range(at: index)
                if range.location != NSNotFound {
                    let text = (string as NSString).substring(with: range) as String
                    ret.append(text)
                }
            }
            return ret
        }

        func parseToBase(from string: String) -> (String, UInt64?)? {
            let regex = try! NSRegularExpression(pattern: ParsingExpressions.baseTypeRegex)
            let s = match(regex: regex, in: string, at: 1).first // match bool tokenId address gid string
            let p = match(regex: regex, in: string, at: 2).first // match uint int bytes
            let n = match(regex: regex, in: string, at: 3).first // match number

            if let prefix = p, !prefix.isEmpty {
                if let n = n, !n.isEmpty {
                    guard let number = UInt64(n) else { fatalError() }
                    return (prefix, number)
                } else {
                    return (prefix, nil)
                }
            } else {
                if let prefix = s {
                    return (prefix, nil)
                } else {
                    return nil
                }
            }
        }

        func parseToArray(from string: String) -> (String, UInt64?)? {
            let regex = try! NSRegularExpression(pattern: ParsingExpressions.arrayTypeRegex)
            let p = match(regex: regex, in: string, at: 1).first
            let l = match(regex: regex, in: string, at: 3).first

            if let prefix = p, !prefix.isEmpty {
                if let l = l, !l.isEmpty {
                    guard let length = UInt64(l) else { fatalError() }
                    return (prefix, length)
                } else {
                    return (prefix, nil)
                }
            } else {
                return nil
            }
        }

        func parseToBase(from prefix: String, number: UInt64?) throws -> ABI.ParameterType {
            if prefix == "uint" {
                if let bits = number {
                    guard bits <= 256 && bits % 8 == 0 else {
                        throw ParsingError.invalidBits
                    }
                }
                return .uint(bits: number)
            } else if prefix == "int" {
                if let bits = number {
                    guard bits <= 256 && bits % 8 == 0 else {
                        throw ParsingError.invalidBits
                    }
                }
                return .int(bits: number)
            } else if prefix == "bytes" {
                if let length = number {
                    guard 0 < length && length <= 32 else {
                        throw ParsingError.invalidLenght
                    }
                    return .bytes(length: length)
                } else {
                    return .dynamicBytes
                }
            } else if prefix == "bool" {
                guard number == nil else { throw ParsingError.invalidString }
                return .bool
            } else if prefix == "tokenId" {
                guard number == nil else { throw ParsingError.invalidString }
                return .tokenId
            } else if prefix == "address" {
                guard number == nil else { throw ParsingError.invalidString }
                return .address
            } else if prefix == "gid" {
                guard number == nil else { throw ParsingError.invalidString }
                return .gid
            } else if prefix == "string" {
                guard number == nil else { throw ParsingError.invalidString }
                return .string
            }
            // impossible
            fatalError()
        }

        if let (prefix, length) = parseToArray(from: string) {
            guard parseToArray(from: prefix) == nil else {
                throw ParsingError.nestArrayUnSupported
            }

            guard let (prefix, number) = parseToBase(from: prefix) else {
                throw ParsingError.invalidString
            }

            let subType = try parseToBase(from: prefix, number: number)
            guard subType.canBeUsedAsSubType else {
                throw ParsingError.subTypeNotSupport(type: subType)
            }

            if let length = length {
                return .array(subType: subType, length: length)
            } else {
                return .dynamicArray(subType: subType)
            }
        } else {
            guard let (prefix, number) = parseToBase(from: string) else {
                throw ParsingError.invalidString
            }
            return try parseToBase(from: prefix, number: number)
        }
    }
}
