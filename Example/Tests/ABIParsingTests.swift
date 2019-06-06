//
//  ABIParsingTests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/6/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import ViteWallet

class ABIParsingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    let successCases = [
        // static
        "uint",
        "uint256",
        "int",
        "int256",
        "bytes32",
        "bool",
        "tokenId",
        "address",
        "gid",
        // dynamic
        "string",
        "bytes",
        // a variable-length array
        "uint[]",
        "uint256[]",
        "int[]",
        "int256[]",
        "bytes32[]",
        "bool[]",
        "tokenId[]",
        "address[]",
        "gid[]",
        // a fixed-length array
        "uint[2]",
        "uint256[44]",
        "int[2]",
        "int256[66]",
        "bytes32[32]",
        "bool[34]",
        "tokenId[68]",
        "address[21]",
        "gid[57]"
    ]

    let failedCases = [
        // invalid string
        "",
        "2",
        "[]",
        "abc",
        "bool3",
        "tokenId4",
        "address5",
        "gid6",
        "string7",
        "_uint",
        "_uint256",
        "_int",
        "_int256",
        "_bytes32",
        "_bool",
        "_tokenId",
        "_address",
        "_gid",
        "_string",
        "_bytes",
        "_uint[]",
        "_uint256[]",
        "_int[]",
        "_int256[]",
        "_bytes32[]",
        "_bool[]",
        "_tokenId[]",
        "_address[]",
        "_gid[]",
        "uint_",
        "uint256_",
        "int_",
        "int256_",
        "bytes32_",
        "bool_",
        "tokenId_",
        "address_",
        "gid_",
        "string_",
        "bytes_",
        "uint[]_",
        "uint256[]_",
        "int[]_",
        "int256[]_",
        "bytes32[]_",
        "bool[]_",
        "tokenId[]_",
        "address[]_",
        "gid[]_",
        "uint[2]_",
        "uint256[44]_",
        "int[2]_",
        "int256[66]_",
        "bytes32[32]_",
        "bool[34]_",
        "tokenId[68]_",
        "address[21]_",
        "gid[57]_",
        // invalid bits
        "uint4",
        "uint512",
        "int9",
        "int1024",
        // invalid length
        "bytes0",
        "bytes33",
        "uint8[0]",
        "int8[a]",
        // invalid subType
        "string[]",
        "string[1]",
        "bytes[]",
        "bytes[2]",
        "uint8[1][]",
        "uint8[][]",
        "int8[1][2]",
        "int8[][2]"
    ]

    func testParsingType() {

        for string in successCases {
            do {
                let type = try ABI.Parsing.parseToType(from: string)
                let ret = (string == type.toString())
                XCTAssert(ret, "\(string) != \(type.toString())")
                if ret {
                    print("🍺 \(string) -> \(type)")
                }
            } catch {
                XCTAssert(false, "❌ \(string): error.localizedDescription")
            }
        }

        for string in failedCases {
            do {
                let type = try ABI.Parsing.parseToType(from: string)
                XCTAssert(false, "❌ \(string) is not \(type.toString())")
            } catch {
                print("🍺 \(string) -> nil")
            }
        }

    }

}
