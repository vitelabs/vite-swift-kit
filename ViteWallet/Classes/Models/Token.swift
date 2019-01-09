//
//  Token.swift
//  Vite
//
//  Created by Stone on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import ObjectMapper
import Vite_HDWalletKit

public struct Token: Mappable {

    public fileprivate(set) var id: String = ""
    public fileprivate(set) var name: String = ""
    public fileprivate(set) var symbol: String = ""
    public fileprivate(set) var decimals: Int = 0

    public init(id: String = "", name: String = "", symbol: String = "", decimals: Int = 0) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
    }

    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        id <- map["tokenId"]
        name <- map["tokenName"]
        symbol <- map["tokenSymbol"]
        decimals <- map["decimals"]
    }
}

extension Token {
    public static func idStriped(_ id: String) -> String {
        guard id.count == 28 else { return "" }
        let string = (id as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        return string
    }

    public static func isValid(string: String) -> Bool {
        guard string.count == 28 else { return false }
        let prefix = (string as NSString).substring(to: 4) as String
        let hash = (string as NSString).substring(with: NSRange(location: 4, length: 20)) as String
        let checksum = (string as NSString).substring(from: 24) as String
        guard prefix == "tti_" else { return false }
        guard checksum == Blake2b.hash(outLength: 2, in: hash.hex2Bytes)?.toHexString() else { return false }
        return true
    }
}
