//
//  ABITests.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2019/6/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import ViteWallet
import Result
import BigInt

class ABITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest(c: ABIEncodeParameterCase) -> String? {
        var errorMessage = ""

        if let msg = doEncodingTest(c: c) {
            errorMessage.append("Encoding: ")
            errorMessage.append(msg)
        }

        if let msg = doDecodingTest(c: c) {
            if !errorMessage.isEmpty {
                errorMessage.append("\n")
            }
            errorMessage.append("Decoding: ")
            errorMessage.append(msg)
        }

        if errorMessage.isEmpty {
            return nil
        } else {
            return errorMessage
        }
    }

    func doEncodingTest(c: ABIEncodeParameterCase) -> String? {
        do {
            let type = try ABI.Parsing.parseToType(from: c.type)
            let r = try ABI.Encoding.encodeParameter(c.value, type: type)
            if c.result == r {
                return nil
            } else {
                return "\(c.result.toHexString()) != \(r.toHexString())"
            }
        } catch {
            return error.localizedDescription
        }
    }

    func doDecodingTest(c: ABIEncodeParameterCase) -> String? {
        do {
            let type = try ABI.Parsing.parseToType(from: c.type)
            let value = try ABI.Decoding.decodeParameter(c.result, type: type)
            if c.value == value.toString() {
                return nil
            } else {
                return "\(c.value) != \(value.toString())"
            }
        } catch {
            return error.localizedDescription
        }
    }

    struct ABIEncodeParameterCase {
        let value: String
        let type: String
        let result: Data

        init(t: String, v: String, r: String) {
            self.type = t
            self.value = v.replacingOccurrences(of: " ", with: "")
            self.result = Data(hex: r.replacingOccurrences(of: "\n", with: ""))
        }
    }

    func testUintEncode() {
        let c = ABIEncodeParameterCase(
            t: "uint256",
            v: "2345675643",
            r: "000000000000000000000000000000000000000000000000000000008bd02b7b")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testIntEncode() {
        let cs = [
            ABIEncodeParameterCase(
                t: "int256",
                v: "2",
                r: "0000000000000000000000000000000000000000000000000000000000000002"),
            ABIEncodeParameterCase(
                t: "int256",
                v: "-2",
                r: "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")
        ]

        for c in cs {
            let errorMessage = doTest(c: c)
            XCTAssert(errorMessage == nil, errorMessage!)
        }
    }

    func testBytesEncode() {
        let c = ABIEncodeParameterCase(
            t: "bytes31",
            v: "01000000000000000000000000000000000000000000000000000000000000",
            r: "0100000000000000000000000000000000000000000000000000000000000000")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testBoolEncode() {
        let cs = [
            ABIEncodeParameterCase(
                t: "bool",
                v: "true",
                r: "0000000000000000000000000000000000000000000000000000000000000001"),
            ABIEncodeParameterCase(
                t: "bool",
                v: "false",
                r: "0000000000000000000000000000000000000000000000000000000000000000")
        ]

        for c in cs {
            let errorMessage = doTest(c: c)
            XCTAssert(errorMessage == nil, errorMessage!)
        }
    }

    func testTokenIdEncode() {
        let c = ABIEncodeParameterCase(
            t: "tokenId",
            v: "tti_5649544520544f4b454e6e40",
            r: "000000000000000000000000000000000000000000005649544520544f4b454e")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testAddressEncode() {
        let cs = [
            ABIEncodeParameterCase(
                t: "address",
                v: "vite_010000000000000000000000000000000000000063bef3da00",
                r: "0000000000000000000000010000000000000000000000000000000000000000"),
            ABIEncodeParameterCase(
                t: "address",
                v: "vite_0000000000000000000000000000000000000003f6af7459b9",
                r: "0000000000000000000000000000000000000000000000000000000000000301")
        ]

        for c in cs {
            let errorMessage = doTest(c: c)
            XCTAssert(errorMessage == nil, errorMessage!)
        }
    }

    func testGidEncode() {
        let c = ABIEncodeParameterCase(
            t: "gid",
            v: "01000000000000000000",
            r: "0000000000000000000000000000000000000000000001000000000000000000")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testStringEncode() {
        let c = ABIEncodeParameterCase(
            t: "string",
            v: "foobar",
            r: """
0000000000000000000000000000000000000000000000000000000000000006
666f6f6261720000000000000000000000000000000000000000000000000000
""")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testDynamicBytesEncode() {
        let c = ABIEncodeParameterCase(
            t: "bytes",
            v: "df3234",
            r: """
0000000000000000000000000000000000000000000000000000000000000003
df32340000000000000000000000000000000000000000000000000000000000
""")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testArrayEncode() {
        let c = ABIEncodeParameterCase(
            t: "uint8[2]",
            v: "[ \"1\", \"2\" ]",
            r: """
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000002
""")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testDynamicArrayEncode() {
        let c = ABIEncodeParameterCase(
            t: "int8[]",
            v: "[ \"1\", \"2\" ]",
            r: """
0000000000000000000000000000000000000000000000000000000000000002
0000000000000000000000000000000000000000000000000000000000000001
0000000000000000000000000000000000000000000000000000000000000002
""")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testABI() {
        let abiString = "{\"type\":\"function\",\"name\":\"myMethod\",\"inputs\":[{\"name\":\"myNumber\",\"type\":\"uint256\"},{\"name\":\"myString\",\"type\":\"string\"}]}"
        let valuesString = "[\"2345675643\",\"Hello!%\"]"
        let ret = "96173f6c000000000000000000000000000000000000000000000000000000008bd02b7b0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000748656c6c6f212500000000000000000000000000000000000000000000000000"

        do {
            let data = try ABI.Encoding.encodeFunctionCall(abiString: abiString, valuesString: valuesString)
            XCTAssert(data.toHexString() == ret, "\(data.toHexString()) != \(ret)")

            let values = try ABI.Decoding.decodeParameters(data, abiString: abiString)
            let string = values.toString()
            XCTAssert(valuesString == string, "\(valuesString) != \(string)")

        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }

    func testddd() {
        let abiString = ABI.BuildIn.dexStakingAsMining.rawValue
        let valuesString = "[\"1\",\"100000000\"]"
//        "[\"tti_5649544520544f4b454e6e40\",\"1000000000000000000\",\"vite_3f6ca91fa4dd04ca4e57dc6acf56161bc84815c1eeb38828f6\"]"
        do {
            let data = try ABI.Encoding.encodeFunctionCall(abiString: abiString, valuesString: valuesString)
            print(data.toHexString())
            print(data.base64EncodedString())
            print("")
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
}
