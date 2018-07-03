//
//  PublicKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation
import CryptoSwift
import secp256k1

public struct PublicKey {
    public let raw: Data
    public let network: Network
    
    init(privateKey: PrivateKey,network:Network) {
        self.raw = Crypto.generatePublicKey(data: privateKey.raw, compressed: false)
        self.network = network
    }
    
    // NOTE: https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki
    public var address: String {
        switch network {
        case .main(let coin):
            switch coin {
            case .bitcoin:
                let prefix = Data([network.publicKeyHash])
                let payload = RIPEMD160.hash(raw.sha256())
                let checksum = (prefix + payload).doubleSHA256.prefix(4)
                return Base58.encode(prefix + payload + checksum)
            case .ethereum:
                let addressData = Crypto.sha3keccak256(data: (Data(hex:"0x") + raw).dropFirst()).suffix(20)
                return "0x" + EIP55.encode(addressData)
            case .litecoin:
                return ""
            }
        case .test:
            return ""
        }
    }
    
    public func get() -> String {
        return self.raw.toHexString()
    }
}

extension Data {
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to: &number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
}
