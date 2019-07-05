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
import BigInt

public struct Token: Mappable {

    public fileprivate(set) var id: String = ""
    public fileprivate(set) var name: String = ""
    public fileprivate(set) var symbol: String = ""
    public fileprivate(set) var decimals: Int = 0
    public fileprivate(set) var index: Int = 0

    public fileprivate(set) var totalSupply: BigInt = 0
    public fileprivate(set) var maxSupply: BigInt = 0
    public fileprivate(set) var owner: ViteAddress = ""
    public fileprivate(set) var ownerBurnOnly: Bool = false
    public fileprivate(set) var isReIssuable: Bool = false

    public init(id: String = "",
                name: String = "",
                symbol: String = "",
                decimals: Int = 0,
                index: Int = 0,
                totalSupply: BigInt = 0,
                maxSupply: BigInt = 0,
                owner: ViteAddress = "",
                ownerBurnOnly: Bool = false,
                isReIssuable: Bool = false) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.index = index

        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.owner = owner
        self.ownerBurnOnly = ownerBurnOnly
        self.isReIssuable = isReIssuable
    }

    public init?(map: Map) {

    }

    public mutating func mapping(map: Map) {
        id <- map["tokenId"]
        name <- map["tokenName"]
        symbol <- map["tokenSymbol"]
        decimals <- map["decimals"]
        index <- map["index"]

        totalSupply <- (map["totalSupply"], JSONTransformer.bigint)
        maxSupply <- (map["maxSupply"], JSONTransformer.bigint)
        owner <- map["owner"]
        ownerBurnOnly <- map["ownerBurnOnly"]
        isReIssuable <- map["isReIssuable"]
    }
}
