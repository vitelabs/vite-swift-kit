//
//  ViteWalletConst.swift
//  Vite
//
//  Created by Stone on 2018/11/20.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import BigInt

public struct ViteWalletConst {
    
    public enum ContractAddress: ViteAddress {
        case pledge = "vite_0000000000000000000000000000000000000003f6af7459b9"
        case consensus = "vite_0000000000000000000000000000000000000004d28108e76b"
        case coin = "vite_000000000000000000000000000000000000000595292d996d"
        case dexFund = "vite_0000000000000000000000000000000000000006e82b8ba657"
        case dexTrade = "vite_00000000000000000000000000000000000000079710f19dc7"
        case defi = "vite_0000000000000000000000000000000000000008e745d12403"

        public var address: ViteAddress {
            return self.rawValue
        }
    }

    public struct ut {
        public static let sendWithoutData: Double = 1
        public static let receive: Double = 1
    }

    public enum ConsensusGroup: String {
        case `private` = "00000000000000000000"
        case snapshot = "00000000000000000001"
        case delegate = "00000000000000000002"

        public var id: String {
            return self.rawValue
        }
    }

    public static let viteToken =
        Token(id: "tti_5649544520544f4b454e6e40",
              name: "VITE",
              symbol: "VITE",
              decimals: 18,
              index: 0,
              totalSupply: BigInt("1002856181980780374120030018")!,
              maxSupply: BigInt("115792089237316195423570985008687907853269984665640564039457584007913129639935")!,
              owner: "vite_0000000000000000000000000000000000000004d28108e76b", ownerBurnOnly: false, isReIssuable: true)
}
