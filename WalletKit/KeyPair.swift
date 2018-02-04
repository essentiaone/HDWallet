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
    private let privateKeyData: Data
    private let chainCodeData: Data
    private let hardens: Bool
    private let network: Network
    
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
    
    /// Check if this KeyPair is the master key pair.
    public var isMasterKeyPair: Bool {
        return depth == 0 && index == 0 && parentFingerprint == 0
    }
    
    /// Root key pair. wallet path is "44'/0'" for mainnet and "44'/1'" for testnet.
    public var rootKeyPair: KeyPair {
        guard isMasterKeyPair else {
            fatalError("Root KeyPair can only be generated from master KeyPair.")
        }
        return derived(at: network.rootKeyPairPath)
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
    
    /// Derive KeyPair at the specified path.
    ///
    /// - Parameter path: the path you want to derive key pair at. should be specified as "44'/0'" or "44'/1'"(if you want it to be hardened).
    /// - Returns: KeyPair derived at the specified path.
    private func derived(at path: String) -> KeyPair {
        var paths = path.components(separatedBy: WalletPath.separator.rawValue)
        if path.hasPrefix(WalletPath.root.rawValue) {
            paths.removeFirst()
        }
        
        var keyPair: KeyPair = self
        paths.forEach { path in
            let hardens = path.hasSuffix(WalletPath.hardenedSymbol.rawValue)
            
            let indexString: String
            if hardens {
                indexString = String(path[path.startIndex..<path.index(path.endIndex, offsetBy: -1)])
            } else {
                indexString = path
            }
            
            guard let index = UInt32(indexString) else {
                fatalError("Unaccesptable index string: \(indexString)")
            }
            
            keyPair = keyPair.derived(at: index, hardens: hardens)
        }
        
        return keyPair
    }
    
    private func derived(at index: UInt32, hardens: Bool) -> KeyPair {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else {
            fatalError("")
        }
        
        var authenticationData = Data()
        if hardens {
            let padding = UInt8(0)
            authenticationData += padding.toHexData
            authenticationData += privateKeyData
        } else {
            authenticationData += publicKeyData
        }
        
        let derivedIndex = hardens ? (edge + index) : index
        authenticationData += derivedIndex.toHexData
        
        let childKeyPairDigest: [UInt8]
        do {
            childKeyPairDigest = try HMAC(key: chainCodeData.bytes, variant: .sha512).authenticate(authenticationData.bytes)
        } catch let error {
            fatalError("HAMC has faild: \(error.localizedDescription)")
        }
        
        let childPrivateKeyData = Data(childKeyPairDigest[0..<32])
        let childChainCodeData = Data(childKeyPairDigest[32..<64])
        
        let factor = BInt(data: childPrivateKeyData)
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let privateKeyNumber = BInt(data: privateKeyData)
        let newPrivateKeyData = ((privateKeyNumber + factor) % curveOrder).toData
        
        return KeyPair(
            privateKeyData: newPrivateKeyData,
            chainCodeData: childChainCodeData,
            depth: depth + 1,
            parentFingerprint: parentFingerprint,// TODO: calcurate currenct fingure print
            index: index,
            hardens: hardens,
            network: network
        )
    }
}
