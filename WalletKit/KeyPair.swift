//
//  KeyPair.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA

public struct KeyPair {
    private let version: UInt32
    private let depth: UInt8
    private let fingurePrint: UInt32
    private let index: UInt32
    private let privateKey: Data
    private let chainCode: Data
    
    public init(privateKey: Data, chainCode: Data, network: Network) {
        self.version = network.version
        self.depth = 0
        self.fingurePrint = 0
        self.index = 0
        self.privateKey = privateKey
        self.chainCode = chainCode
    }
    
    public var publicKey: String {
        return publicKeyData.toHexString()
    }
    
    private var publicKeyData: Data {
        return ECDSA.secp256k1.generatePublicKey(with: privateKey, isCompressed: true)
    }
    
    public var extendedPrivateKey: String {
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    private var extendedPrivateKeyData: Data {
        var extendedPrivateKeyData = generateBaseKey()
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKey
        return extendedPrivateKeyData
    }
    
    public var extendedPublicKey: String {
        return extendedPublicKeyData.base58BaseEncodedString
    }
    
    private var extendedPublicKeyData: Data {
        var extendedPublicKeyData = generateBaseKey()
        extendedPublicKeyData += publicKeyData
        return extendedPublicKeyData
    }
    
    private func generateBaseKey() -> Data {
        var baseKeyData = Data()
        baseKeyData += depth.toHexData
        baseKeyData += fingurePrint.toHexData
        baseKeyData += index.toHexData
        baseKeyData += chainCode
        return baseKeyData
    }
}
