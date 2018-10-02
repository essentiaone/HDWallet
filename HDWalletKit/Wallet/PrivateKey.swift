//
//  PrivateKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation

public struct PrivateKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let coin: Coin
    
    public init(seed: Data, coin: Coin) {
        let output = Crypto.HMACSHA512(key: "Bitcoin seed".data(using: .ascii)!, data: seed)
        self.raw = output[0..<32]
        self.chainCode = output[32..<64]
        self.depth = 0
        self.fingerprint = 0
        self.index = 0
        self.coin = coin
    }
    
    private init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, coin: Coin) {
        self.raw = privateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.coin = coin
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self, chainCode: chainCode, coin: coin, depth: depth, fingerprint: fingerprint, index: index)
    }
    
    public var extended: String {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += coin.privateKeyVersion.bigEndian
        extendedPrivateKeyData += depth.littleEndian
        extendedPrivateKeyData += fingerprint.littleEndian
        extendedPrivateKeyData += index.littleEndian
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0)
        extendedPrivateKeyData += raw
        let checksum = extendedPrivateKeyData.doubleSHA256.prefix(4)
        return Base58.encode(extendedPrivateKeyData + checksum)
    }
    
    private func wif() -> String {
        var data = Data()
        data += coin.wifPreifx
        data += raw
        data += UInt8(0x01)
        data += data.doubleSHA256.prefix(4)
        return Base58.encode(data)
    }
    
    public func get() -> String {
        switch self.coin {
        case .bitcoin: fallthrough
        case .litecoin: fallthrough
        case .bitcoinCash:
            return self.wif()
        case .ethereum:
            return self.raw.toHexString()
        }
    }
    
    public func derived(at node:DerivationNode) -> PrivateKey {
        let edge: UInt32 = 0x80000000
        guard (edge & node.index) == 0 else { fatalError("Invalid child index") }
        
        var data = Data()
        switch node {
        case .hardened:
            data += UInt8(0)
            data += raw
        case .notHardened:
            data += Crypto.generatePublicKey(data: raw, compressed: true)
        }
        
        let derivingIndex = CFSwapInt32BigToHost(node.hardens ? (edge | node.index) : node.index)
        data += derivingIndex
        
        let digest = Crypto.HMACSHA512(key: chainCode, data: data)
        let factor = BInt(data: digest[0..<32])
        
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let derivedPrivateKey = ((BInt(data: raw) + factor) % curveOrder).data
        
        let derivedChainCode = digest[32..<64]
        let fingurePrint: UInt32 = RIPEMD160.hash(publicKey.rawCompressed.sha256()).withUnsafeBytes { $0.pointee }
        
        return PrivateKey(
            privateKey: derivedPrivateKey,
            chainCode: derivedChainCode,
            depth: depth + 1,
            fingerprint: fingurePrint,
            index: derivingIndex,
            coin: coin
        )
    }
    
    public func sign(hash: Data) throws -> Data {
        return try Crypto.sign(hash, privateKey: raw)
    }
}

