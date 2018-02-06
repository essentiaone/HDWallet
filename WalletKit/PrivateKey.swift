//
//  PrivateKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import CryptoSwift

public struct PrivateKey {
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    public let privateKey: Data
    public let chainCode: Data
    
    init(seed: Data, network: Network) {
        self.depth = 0
        self.fingerprint = 0
        self.index = 0
        self.network = network
        
        let output = Crypto.HMACSHA512(key: "Bitcoin seed", data: seed)
        self.privateKey = output[0..<32]
        self.chainCode = output[32..<64]
    }
    
    init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.privateKey = privateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self, chainCode: chainCode, network: network, depth: depth, fingerprint: fingerprint, index: index)
    }
    
    public var extended: String {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyVersion.toHexData
        extendedPrivateKeyData += depth.toHexData
        extendedPrivateKeyData += fingerprint.toHexData
        extendedPrivateKeyData += index.toHexData
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKey
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    public func derived(at index: UInt32, hardens: Bool = false) -> PrivateKey {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else { fatalError("Invalid child index") }
        
        var data = Data()
        if hardens {
            data += UInt8(0).toHexData
            data += privateKey
        } else {
            data += publicKey.publicKey
        }
        
        let derivingIndex = hardens ? (edge + index) : index
        data += derivingIndex.toHexData
        
        let digest = Crypto.HMACSHA512(key: chainCode, data: data)
        let factor = BInt(data: digest[0..<32])
        
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let derivedPrivateKey = ((BInt(data: privateKey) + factor) % curveOrder).toData
        
        let derivedChainCode = digest[32..<64]
        let fingurePrint = UInt32(bytes: publicKey.publicKey.hash160.prefix(4))
        
        return PrivateKey(
            privateKey: derivedPrivateKey,
            chainCode: derivedChainCode,
            depth: depth + 1,
            fingerprint: fingurePrint,
            index: derivingIndex,
            network: network
        )
    }
}
