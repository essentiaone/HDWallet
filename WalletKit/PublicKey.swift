//
//  PublicKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation
import CryptoSwift

public struct PublicKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    private let privateKey: PrivateKey
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.raw = Crypto.generatePublicKey(data: privateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.privateKey = privateKey
    }
    
    // NOTE: https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki
    public var address: String {
        let prefix = Data([network.publicKeyHash])
        let payload = RIPEMD160.hash(raw.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    public var redeemScript: Data    {
        var redeem = Data([0x00, 0x14])
        redeem.append(RIPEMD160.hash(raw.sha256()))
        return redeem
    }

    public var outputScript: Data    {
        var script = Data([0xa9, 0x14])
        script.append(RIPEMD160.hash(redeemScript.sha256()))
        script.append(Data([0x87]))
        return script
    }

    public var addressBIP49: String {
        let prefix = Data([network.scriptHash])
        let payload = RIPEMD160.hash(redeemScript.sha256())
        let checksum = (prefix + payload).doubleSHA256.prefix(4)
        return Base58.encode(prefix + payload + checksum)
    }
    
    public var addressBIP84: String {
        let addrCoder = SegwitAddrCoder()
        var address : String
        do  {
            address = try addrCoder.encode(hrp: network.bech32, version: 0x00, program: RIPEMD160.hash(raw.sha256()))
        }
        catch {
            address = "";
        }
        
        return address
    }
    
    public var extended: String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyVersion.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += index.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        let checksum = extendedPublicKeyData.doubleSHA256.prefix(4)
        return Base58.encode(extendedPublicKeyData + checksum)
    }
}
