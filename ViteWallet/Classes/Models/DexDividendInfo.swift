//
//  DexDividendInfo.swift
//  ViteWallet
//
//  Created by vite on 2022/4/20.
//

import Foundation
import ObjectMapper

public struct DexDividendInfo {

    public fileprivate(set) var btc = Amount()
    public fileprivate(set) var eth = Amount()
    public fileprivate(set) var usdt = Amount()
    
    public init(btc: Amount = 0, eth: Amount = 0, usdt: Amount = 0) {
        self.btc = btc
        self.eth = eth
        self.usdt = usdt
    }
}




