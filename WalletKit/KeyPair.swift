//
//  KeyPair.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA

public struct KeyPair {
    private let network: Network
    private let depth: UInt8
    private let fingurePrint: UInt32
    private let index: UInt32
    private let privateKeyData: Data
    private let chainCodeData: Data
    
    internal init(privateKeyData: Data, chainCodeData: Data, network: Network) {
        self.network = network
        self.depth = 0
        self.fingurePrint = 0
        self.index = 0
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
    }
    
    public var privateKey: String {
        return privateKeyData.toHexString()
    }
    
    public var publicKey: String {
        return publicKeyData.toHexString()
    }
    
    private var publicKeyData: Data {
        return ECDSA.secp256k1.generatePublicKey(with: privateKeyData, isCompressed: true)
    }
    
    public var extendedPrivateKey: String {
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    private var extendedPrivateKeyData: Data {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyVersion.toHexData
        extendedPrivateKeyData += generateKeyComponentData()
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKeyData
        return extendedPrivateKeyData
    }
    
    public var extendedPublicKey: String {
        return extendedPublicKeyData.base58BaseEncodedString
    }
    
    private var extendedPublicKeyData: Data {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.toHexData
        extendedPublicKeyData += generateKeyComponentData()
        extendedPublicKeyData += publicKeyData
        return extendedPublicKeyData
    }
    
    private func generateKeyComponentData() -> Data {
        var baseKeyData = Data()
        baseKeyData += depth.toHexData
        baseKeyData += fingurePrint.toHexData
        baseKeyData += index.toHexData
        baseKeyData += chainCodeData
        return baseKeyData
    }
}
