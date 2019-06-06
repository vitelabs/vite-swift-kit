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

class ABITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest(c: ABIEncodeParameterCase) -> String? {
        do {
            let type = try ABI.Parsing.parseToType(from: c.type)
            let r = try ABI.Encoding.encodeParameter(c.value, type: type)
            XCTAssert(c.result == r)
            if c.result == r {
                return nil
            } else {
                return "\(c.result.toHexString()) != \(r.toHexString())"
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
            self.value = v
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
        let c = ABIEncodeParameterCase(
            t: "int256",
            v: "2",
            r: "0000000000000000000000000000000000000000000000000000000000000002")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testBytesEncode() {
        let c = ABIEncodeParameterCase(
            t: "bytes32",
            v: "0x0100000000000000000000000000000000000000000000000000000000000000",
            r: "0100000000000000000000000000000000000000000000000000000000000000")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
    }

    func testBoolEncode() {
        let c = ABIEncodeParameterCase(
            t: "int256",
            v: "2",
            r: "0000000000000000000000000000000000000000000000000000000000000002")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
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
        let c = ABIEncodeParameterCase(
            t: "address",
            v: "vite_010000000000000000000000000000000000000063bef3da00",
            r: "0000000000000000000000010000000000000000000000000000000000000000")

        let errorMessage = doTest(c: c)
        XCTAssert(errorMessage == nil, errorMessage!)
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
            v: "0xdf3234",
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
            v: "[ \"1\", 2 ]",
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
}
