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

        public var address: ViteAddress {
            return self.rawValue
        }
    }

    public enum ConsensusGroup: String {
        case `private` = "00000000000000000000"
        case snapshot = "00000000000000000001"
        case delegate = "00000000000000000002"

        public var id: String {
            return self.rawValue
        }
    }

    public static let viteToken = Token(id: "tti_5649544520544f4b454e6e40", name: "Vite Token", symbol: "VITE", decimals: 18)
}
