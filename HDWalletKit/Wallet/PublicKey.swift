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
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.raw = Crypto.generatePublicKey(data: privateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
    }
    
    // NOTE: https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki
    public var address: String {
        switch network.coin {
        case .bitcoin: fallthrough
        case .bitcoinCash: fallthrough
        case .litecoin:
            return generateBtcAddress()
        case .ethereum:
            return generateEthAddress()
        }
    }
    
    func generateBtcAddress() -> String {
        let prefix = Data([network.publicKeyHash])
        let payload = RIPEMD160.hash(raw.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    func generateEthAddress() -> String {
        let formattedData = (Data(hex: network.addressPrefix) + raw).dropFirst()
        let addressData = Crypto.sha3keccak256(data: formattedData).suffix(20)
        return network.addressPrefix + EIP55.encode(addressData)
    }
    
    public var extended: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += index.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        let checksum = extendedPublicKeyData.doubleSHA256.prefix(4)
        return Base58.encode(extendedPublicKeyData + checksum)
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
