//
//  Box.swift
//  ViteWallet_Tests
//
//  Created by Stone on 2018/12/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ViteWallet

struct Box {

    static let viteTokenId = ViteWalletConst.viteToken.id
    static let encryptedKey = "123456"

    static var wallet: Wallet = {
        let mnemonic = "nuclear buzz drift segment state heavy leaf pistol frozen casual wall kit pitch feel prevent donor idea track oil inside have lens purity wisdom"
        let wallet = Wallet(uuid: "1", name: "2", mnemonic: mnemonic, language: .english, encryptedKey: encryptedKey)
        return wallet
    }()

    static var firstAccount = try! wallet.account(at: 0, encryptedKey: encryptedKey)
    static var secondAccount = try! wallet.account(at: 1, encryptedKey: encryptedKey)
}
