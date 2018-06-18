//
//  PublicKey.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation
import CryptoSwift
import secp256k1

public struct PublicKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    private let privateKey: PrivateKey?
    
    public enum Errors: LocalizedError {
        case base58DecodingFailed
        case invalidKey
        case invalidTweak
        case invalidIndex
        case failedToCreateContext
        
        public var errorDescription: String? {
            switch self {
            case .base58DecodingFailed:
                return "Failed to decode xpub"
            case .invalidKey:
                return "Not a valid key"
            case .invalidTweak:
                return "Not a valid tweak"
            case .invalidIndex:
                return "Not a valid index"
            case .failedToCreateContext:
                return "Failed to create a new context"
            }
        }
    }
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.raw = Crypto.generatePublicKey(data: privateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.privateKey = privateKey
    }
    
    public init (raw: Data, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.raw = raw
        self.chainCode = chainCode
        self.network = network
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.privateKey = nil
    }
    
    public init(xpub: String, network: Network, index: UInt32) throws {
        guard let decoded = xpub.base58CheckDecodedData else { throw Errors.base58DecodingFailed }
        self.fingerprint = UInt32(Data(bytes: decoded.bytes[5...8]).uint8)
        self.raw = Data(bytes: decoded.bytes[45...77])
        self.depth = decoded.bytes[4]
        self.chainCode = Data(bytes: decoded.bytes[13...44])
        self.index = index
        self.network = network
        self.privateKey = nil
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
    
    public func derived(at index: UInt32) throws -> PublicKey {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else { throw Errors.invalidIndex }
        
        var data = Data()
        data += raw
        data += index.bigEndian
        
        let digest = Crypto.HMACSHA512(key: chainCode, data: data)
        let tweak = Data(digest[0..<32])
        let derivedChainCode = digest[32..<64]
        
        guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)) else { throw Errors.failedToCreateContext }
        
        guard tweak.count == 32 else { throw Errors.invalidTweak }
        var pub = secp256k1_pubkey()
        let parseResult = raw.withUnsafeBytes {
            secp256k1_ec_pubkey_parse(context, &pub, $0, raw.count)
        }
        
        guard parseResult == 1 else { throw Errors.invalidKey }
        
        let tweakResult = tweak.withUnsafeBytes {
            secp256k1_ec_pubkey_tweak_add(context, &pub, $0)
        }
        
        guard tweakResult == 1 else { throw Errors.invalidTweak }
        
        let length = 33
        var publicKey = Data(count: length)
        let flags = SECP256K1_EC_COMPRESSED
        publicKey.withUnsafeMutableBytes { (buffer: UnsafeMutablePointer<UInt8>) -> Void in
            var len = length
            secp256k1_ec_pubkey_serialize(context, buffer, &len, &pub, UInt32(flags))
            return Void()
        }
        
        return PublicKey(raw: publicKey, chainCode: derivedChainCode, network: self.network, depth: self.depth + 1, fingerprint: self.fingerprint, index: self.index)
    }
}

extension Data {
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to: &number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
}
