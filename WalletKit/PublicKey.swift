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
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.raw = ECDSA.secp256k1.generatePublicKey(with: privateKey.raw, isCompressed: true)
        self.chainCode = chainCode
    }
    
    public var address: String {
        let hash = raw.hash160
        let checksum = hash.doubleSHA256.prefix(4)
        return (hash + checksum).base58BaseEncodedString
    }
    
    public var extended: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += index.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        return extendedPublicKeyData.base58BaseEncodedString
    }
}
