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
    private let network: Network
    
    private let privateKeyData: Data
    private let chainCodeData: Data
    
    internal init(privateKeyData: Data, chainCodeData: Data, depth: UInt8, parentFingerprint: UInt32, index: UInt32, network: Network) {
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
        self.depth = depth
        self.parentFingerprint = parentFingerprint
        self.index = index
        self.network = network
    }
    
    /// Initialize MasterKeyPair
    ///
    /// - Parameters:
    ///   - privateKeyData: private key in data format, generated from seed string.
    ///   - chainCodeData: chain code in data format, generated from seed string.
    ///   - hardens: wthether the key pair should hardened or not.
    ///   - network:
    internal init(privateKeyData: Data, chainCodeData: Data, network: Network) {
        self.depth = 0
        self.parentFingerprint = 0
        self.index = 0
        self.privateKeyData = privateKeyData
        self.chainCodeData = chainCodeData
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
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyVersion.toHexData
        extendedPrivateKeyData += depth.toHexData
        extendedPrivateKeyData += parentFingerprint.toHexData
        extendedPrivateKeyData += index.toHexData
        extendedPrivateKeyData += chainCodeData
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKeyData
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    /// Extended public key in String format, encoded in Base58
    public var extendedPublicKey: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.toHexData
        extendedPublicKeyData += depth.toHexData
        extendedPublicKeyData += parentFingerprint.toHexData
        extendedPublicKeyData += index.toHexData
        extendedPublicKeyData += chainCodeData
        extendedPublicKeyData += publicKeyData
        return extendedPublicKeyData.base58BaseEncodedString
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
            network: network
        )
    }
}
