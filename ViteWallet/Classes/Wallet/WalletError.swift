//
//  Wallet.swift
//  ViteWallet
//
//  Created by Stone on 2018/12/7.
//

import Foundation

extension  Wallet {

    public enum WalletError: Error {
        case invalidEncryptedKey
        case invalidTokenId
    }
}
