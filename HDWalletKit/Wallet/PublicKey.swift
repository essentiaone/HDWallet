//
//  PublicKey.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation
import CryptoSwift
import secp256k1

public struct PublicKey {
    public let compressedPublicKey: Data
    public let uncompressedPublicKey: Data
    public let coin: Coin
    
    public init(privateKey: Data, coin: Coin) {
        self.compressedPublicKey = Crypto.generatePublicKey(data: privateKey, compressed: true)
        self.uncompressedPublicKey = Crypto.generatePublicKey(data: privateKey, compressed: false)
        self.coin = coin
    }
    
    public init(base58: Data, coin: Coin) {
        let publickKey = Base58.encode(base58)
        self.compressedPublicKey = Data(hex: publickKey)
        self.uncompressedPublicKey = Data(hex: publickKey)
        self.coin = coin
    }
    
    // NOTE: https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki
    public var address: String {
        switch coin {
        case .dogecoin: fallthrough
        case .bitcoin: fallthrough
        case .dash: fallthrough
        case .bitcoinCash: fallthrough
        case .litecoin:
            return generateBtcAddress()
        case .ethereum:
            return generateEthAddress()
        }
    }
    
    public var utxoAddress: Address {
        switch coin {
        case .bitcoin, .litecoin, .dash, .bitcoinCash, .dogecoin:
            return try! LegacyAddress(address, coin: coin)
        case .ethereum:
            fatalError("Coin does not support UTXO address")
        }
    }
    
    func generateBtcAddress() -> String {
        let prefix = Data([coin.publicKeyHash])
        let payload = RIPEMD160.hash(compressedPublicKey.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    func generateCashAddress() -> String {
        let prefix = Data([coin.publicKeyHash])
        let payload = RIPEMD160.hash(compressedPublicKey.sha256())
        return Bech32.encode(prefix + payload, prefix: coin.scheme)
    }
    
    func generateEthAddress() -> String {
        let formattedData = (Data(hex: coin.addressPrefix) + uncompressedPublicKey).dropFirst()
        let addressData = Crypto.sha3keccak256(data: formattedData).suffix(20)
        return coin.addressPrefix + EIP55.encode(addressData)
    }
    
    public func get() -> String {
        return compressedPublicKey.toHexString()
    }
    
    public var data: Data {
        return Data(hex: get())
    }
}
