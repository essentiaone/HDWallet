//
//  KeyPair.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA
import CryptoSwift

/// KeyPair has PrivateKey and corresponding PublicKey. It also has all the information
/// (eg, depth, fingureprint, index) necessory for generating a key pair.
public struct KeyPair {
    
    private let depth: UInt8
    private let parentFingerprint: UInt32
    private let index: UInt32
    private let hardens: Bool
    private let network: Network
    
    private let privateKeyData: Data
    private let chainCodeData: Data
    
    internal init(privateKeyData: Data, chainCodeData: Data, depth: UInt8, parentFingerprint: UInt32, index: UInt32, hardens: Bool, network: Network) {
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
        self.depth = depth
        self.parentFingerprint = parentFingerprint
        self.index = index
        self.hardens = hardens
        self.network = network
    }
    
    /// Initialize MasterKeyPair
    ///
    /// - Parameters:
    ///   - privateKeyData: private key in data format, generated from seed string.
    ///   - chainCodeData: chain code in data format, generated from seed string.
    ///   - hardens: wthether the key pair should hardened or not.
    ///   - network:
    internal init(privateKeyData: Data, chainCodeData: Data, hardens: Bool, network: Network) {
        self.depth = 0
        self.parentFingerprint = 0
        self.index = 0
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
        self.hardens = hardens
        self.network = network
    }
    
    /// Bitcoin address for this public key
    public var address: String {
        let hash = publicKeyData.hash160
        let checksum = hash.doubleSHA256.prefix(4)
        return (hash + checksum).base58BaseEncodedString
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
        baseKeyData += parentFingerprint.toHexData
        let childIndex = hardens ? (0x80000000 | index) : index
        baseKeyData += childIndex.toHexData
        baseKeyData += chainCodeData
        return baseKeyData
    }
    
    
    /// Derive private key at the specified index
    ///
    /// - Parameters:
    ///   - index: index you want to derive at
    ///   - hardens: whether you want it to be hardened
    /// - Returns: derived key pair
    public func derive(at index: UInt32, hardens: Bool) -> KeyPair {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else {
            fatalError("") // TODO: fix
        }
        
        var data = Data()
        if hardens {
            data += UInt8(0).toHexData
            data += privateKeyData
        } else {
            data += publicKeyData
        }
        
        let derivedIndex = hardens ? (edge + index) : index
        data += derivedIndex.toHexData
        
        let digest: [UInt8]
        do {
            digest = try HMAC(key: chainCodeData.bytes, variant: .sha512).authenticate(data.bytes)
        } catch let error {
            fatalError("HAMC has faild: \(error.localizedDescription)")
        }
        
        let derivedPrivateKeyData = Data(digest[0..<32])
        let derivedChainCode = Data(digest[32..<64])
        
        let factor = BInt(data: derivedPrivateKeyData)
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let privateKeyNumber = BInt(data: privateKeyData)
        let newPrivateKeyData = ((privateKeyNumber + factor) % curveOrder).toData
        
        let fingurePrint = UInt32(bytes: publicKeyData.hash160.bytes.prefix(4))
        
        return KeyPair(
            privateKeyData: newPrivateKeyData,
            chainCodeData: derivedChainCode,
            depth: depth + 1,
            parentFingerprint: fingurePrint,
            index: derivedIndex,
            hardens: hardens,
            network: network
        )
    }
}
