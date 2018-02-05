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
    
    init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.privateKey = privateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
    }
    
    init(seed: Data, network: Network) {
        self.depth = 0
        self.fingerprint = 0
        self.index = 0
        self.network = network
        
        let output = Crypto.HMACSHA512(key: "Bitcoin seed", data: seed)
        self.privateKey = Data(output[0..<32])
        self.chainCode = Data(output[32..<64])
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
}
