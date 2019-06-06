//
//  ViteGId.swift
//  ViteWallet
//
//  Created by Stone on 2019/6/3.
//

import Foundation
import Vite_HDWalletKit

public typealias ViteGId = String

public extension ViteTokenId {

    public var isViteGId: Bool {
        return rawViteGId != nil
    }

    public var rawViteGId: Bytes? {
        let bytes = Bytes(hex: self)
        guard bytes.count == 10 else { return nil }
        return bytes
    }
}


