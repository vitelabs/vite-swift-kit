//
//  Wallet.swift
//  ViteWallet
//
//  Created by Stone on 2018/12/7.
//

import Foundation
import Vite_HDWalletKit

extension  Wallet {

    open class Account {

        public let secretKey: String
        public let publicKey: String
        public let address: ViteAddress

        public init(secretKey: String, publicKey: String, address: ViteAddress) {
            self.secretKey = secretKey
            self.publicKey = publicKey
            self.address = address
        }

        open func sign(hash: Bytes) -> Bytes {
            return Ed25519.sign(message: hash, secretKey: secretKey.hex2Bytes, publicKey: publicKey.hex2Bytes)
        }
    }
}
