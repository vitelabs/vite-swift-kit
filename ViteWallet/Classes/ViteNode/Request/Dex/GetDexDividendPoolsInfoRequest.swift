//
//  GetDexDividendPoolsInfoRequest.swift
//  ViteBusiness
//
//  Created by vite on 2022/4/20.
//

import Foundation
import JSONRPCKit
import SwiftyJSON
import ObjectMapper

public struct GetDexDividendPoolsInfoRequest: JSONRPCKit.Request {
    public typealias Response = DexDividendInfo

    public var method: String {
        return "dex_getDividendPoolsInfo"
    }

    public var parameters: Any? {
        return []
    }

    public init() {
    }

    public func response(from resultObject: Any) throws -> Response {

        if let _ = resultObject as? NSNull {
            return DexDividendInfo()
        }

        guard let response = resultObject as? [String: Any] else {
            throw ViteError.JSONTypeError
        }

        var ret = [String: Amount]()
        var array = [[String: Any]]()
        if let a = Array(response.values) as? [[String: Any]] {
            array = a
        }
        
        var btc = Amount()
        var eth = Amount()
        var usdt = Amount()
        
        for item in array {
            let json = JSON(item)
            if let amountString = json["amount"].string,
               let amount = Amount(amountString),
               let tokenSymbol = json["tokenInfo"]["tokenSymbol"].string {
                if tokenSymbol == "BTC" {
                    btc = amount
                } else if tokenSymbol == "ETH" {
                    eth = amount
                } else if tokenSymbol == "USDT" {
                    usdt = amount
                }
            }
        }
        
        return DexDividendInfo(btc: btc, eth: eth, usdt: usdt)
    }
}
