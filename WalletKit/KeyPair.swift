//
//  KeyPair.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA

/// KeyPair has PrivateKey and corresponding PublicKey. It also has all the information
/// (eg, depth, fingureprint, index) necessory for generating a key pair.
public struct KeyPair {
    
    private let depth: UInt8
    private let fingurePrint: UInt32
    private let index: UInt32
    private let privateKeyData: Data
    private let chainCodeData: Data
    private let hardens: Bool
    private let network: Network
    
    internal init(privateKeyData: Data, chainCodeData: Data, hardens: Bool, network: Network) {
        self.depth = 0
        self.fingurePrint = 0
        self.index = 0
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
        self.hardens = hardens
        self.network = network
    }
    
    /// Private key in String format, encoded in Base58
    public var privateKey: String {
        return privateKeyData.toHexString()
    }
    
    /// Public key in String format, encoded in Base58
    public var publicKey: String {
        return publicKeyData.toHexString()
    }
    
    /// Public key in Data format.
    private var publicKeyData: Data {
        return ECDSA.secp256k1.generatePublicKey(with: privateKeyData, isCompressed: true)
    }
    
    /// Extended private key in String format, encoded in Base58
    public var extendedPrivateKey: String {
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    /// Extended private key in Data format.
    private var extendedPrivateKeyData: Data {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyVersion.toHexData
        extendedPrivateKeyData += generateKeyComponentData()
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKeyData
        return extendedPrivateKeyData
    }
    
    /// Extended public key in String format, encoded in Base58
    public var extendedPublicKey: String {
        return extendedPublicKeyData.base58BaseEncodedString
    }
    
    /// Extended public key in Data format.
    private var extendedPublicKeyData: Data {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.toHexData
        extendedPublicKeyData += generateKeyComponentData()
        extendedPublicKeyData += publicKeyData
        return extendedPublicKeyData
    }
    
    /// Generate a key component data with depth, fingure print, index, and chain code.
    ///
    /// - Returns: data including depth, fingure print, index, and chain code.
    private func generateKeyComponentData() -> Data {
        var baseKeyData = Data()
        baseKeyData += depth.toHexData
        baseKeyData += fingurePrint.toHexData
        let childIndex = hardens ? (0x80000000 | index) : index
        baseKeyData += childIndex.toHexData
        baseKeyData += chainCodeData
        return baseKeyData
    }
}
