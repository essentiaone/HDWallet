//
//  PublicKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA
import CryptoSwift

public struct PublicKey {
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    public let publicKey: Data
    public let chainCode: Data
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.publicKey = ECDSA.secp256k1.generatePublicKey(with: privateKey.privateKey, isCompressed: true)
        self.chainCode = chainCode
    }
    
    public var address: String {
        let hash = publicKey.hash160
        let checksum = hash.doubleSHA256.prefix(4)
        return (hash + checksum).base58BaseEncodedString
    }
    
    public var extended: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.toHexData
        extendedPublicKeyData += depth.toHexData
        extendedPublicKeyData += fingerprint.toHexData
        extendedPublicKeyData += index.toHexData
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += publicKey
        return extendedPublicKeyData.base58BaseEncodedString
    }
}
