//
//  Wallet.swift
//  ViteWallet
//
//  Created by Stone on 2018/12/7.
//

import Foundation
import ObjectMapper
import Vite_HDWalletKit
import CryptoSwift

public class Wallet: Mappable {

    public fileprivate(set) var uuid: String
    public fileprivate(set) var name: String
    public fileprivate(set) var ciphertext: String
    public fileprivate(set) var language: MnemonicCodeBook
    public fileprivate(set) var hash: String

    private var _mnemonic: String?
    private var _seed: String?
    private var _encryptedKey: String?

    public required init?(map: Map) {
        uuid = ""
        name = ""
        ciphertext = ""
        language = .english
        hash = ""
    }

    public init(uuid: String,
                name: String,
                mnemonic: String,
                language: MnemonicCodeBook,
                encryptedKey: String) {

        self.uuid = uuid
        self.name = name
        self.ciphertext = type(of: self).encrypt(plaintext: mnemonic, language: language, encryptedKey: encryptedKey)
        self.language = language


        let seed = Mnemonic.createBIP39Seed(mnemonic: mnemonic).toHexString()
        _mnemonic = mnemonic
        _seed = seed
        _encryptedKey = encryptedKey

        guard let (_, _, address) = HDBip.accountsForIndex(0, seed: seed) else { fatalError() }
        self.hash = address.sha1()
    }

    public func mapping(map: Map) {
        uuid <- map["uuid"]
        name <- map["name"]
        ciphertext <- map["ciphertext"]
        language <- map["language"]
        hash <- map["hash"]
    }

    public func toCipherJSONString() -> String {
        return self.toJSONString() ?? ""
    }
}

extension  Wallet {

   public func account(at index: Int, encryptedKey: String) throws -> Account {

        if let _ = _seed {
            guard _encryptedKey == encryptedKey else { throw WalletError.invalidEncryptedKey }
        } else {
            guard let mnemonic = type(of: self).decrypt(ciphertext: ciphertext, language: language, encryptedKey: encryptedKey) else { throw WalletError.invalidEncryptedKey }
            let seed = Mnemonic.createBIP39Seed(mnemonic: mnemonic).toHexString()
            _mnemonic = mnemonic
            _seed = seed
            _encryptedKey = encryptedKey
        }

        guard let seed = _seed else { fatalError() }
        guard let (secretKey, publicKey, address) = HDBip.accountsForIndex(index, seed: seed) else { fatalError() }
        return Account(secretKey: secretKey, publicKey: publicKey, address: Address(string: address))
    }
}

extension  Wallet {

    static let gcm = GCM(iv: "vite mnemonic iv".md5().hex2Bytes, mode: .combined)

    static func encrypt(plaintext: String, language: MnemonicCodeBook, encryptedKey: String) -> String {
        do {
            guard let data = encryptedKey.data(using: .utf8) else { fatalError() }
            guard let entropy = Mnemonic.mnemonicsToEntropy(plaintext, language: language) else { fatalError() }
            let key = [UInt8](data.sha256())
            let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
            let cipher = try aes.encrypt([UInt8](entropy))
            return cipher.toHexString()
        } catch {
            fatalError()
        }
    }

    static func decrypt(ciphertext: String, language: MnemonicCodeBook, encryptedKey: String) -> String? {
        do {
            guard let data = encryptedKey.data(using: .utf8) else { return nil }
            let key = [UInt8](data.sha256())
            let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
            let entropy = try aes.decrypt(ciphertext.hex2Bytes)
            return Mnemonic.generator(entropy: Data(bytes: entropy), language: language)
        } catch {
            return nil
        }
    }

    static func mnemonicHash(mnemonic: String) -> String {
        let seed = Mnemonic.createBIP39Seed(mnemonic: mnemonic).toHexString()
        guard let (_, _, address) = HDBip.accountsForIndex(0, seed: seed) else { fatalError() }
        return address.sha1()
    }
}
