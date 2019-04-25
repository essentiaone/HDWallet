//
//  EllipticCurveEncrypterSecp256k1.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import secp256k1
import CryptoSwift

public class EllipticCurveEncrypterSecp256k1 {
    // holds internal state of the c library
    private let context: OpaquePointer
    
    public init() {
        context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
    }
    
    deinit {
        secp256k1_context_destroy(context)
    }
    
    /// Recovers public key from the PrivateKey. Use import(signature:) to convert signature from bytes.
    ///
    /// - Parameters:
    ///   - privateKey: private key bytes
    /// - Returns: public key structure
    public func createPublicKey(privateKey: Data) -> secp256k1_pubkey {
        let privateKey = privateKey.bytes
        var publickKey = secp256k1_pubkey()
        _ = SecpResult(secp256k1_ec_pubkey_create(context, &publickKey, privateKey))
        return publickKey
    }
    
    /// Signs the hash with the private key. Produces signature data structure that can be exported with
    /// export(signature:) method.
    ///
    /// - Parameters:
    ///   - hash: 32-byte (256-bit) hash of the message
    ///   - privateKey: 32-byte private key
    /// - Returns: signature data structure if signing succeeded, otherwise nil.
    public func sign(hash: Data, privateKey: Data) -> secp256k1_ecdsa_recoverable_signature? {
        precondition(hash.count == 32, "Hash must be 32 bytes size")
        var signature = secp256k1_ecdsa_recoverable_signature()
        privateKey.withUnsafeBytes { privateKey -> Void in
            guard let privateKeyPtr = privateKey.bindMemory(to: UInt8.self).baseAddress else { return }
            hash.withUnsafeBytes { hash -> Void in
                guard let hashPtr = hash.bindMemory(to: UInt8.self).baseAddress else { return }
                secp256k1_ecdsa_sign_recoverable(context, &signature, hashPtr, privateKeyPtr, nil, nil)
            }
        }
        return signature
    }
    
    /// Converts signature data structure to 65 bytes.
    ///
    /// - Parameter signature: signature data structure
    /// - Returns: 65 byte exported signature data.
    public func export(signature: inout secp256k1_ecdsa_recoverable_signature) -> Data {
        var output = Data(count: 65)
        var recId = 0 as Int32
        _ = output.withUnsafeMutableBytes { output in
            guard let p = output.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, p, &recId, &signature)
        }
        
        output[64] = UInt8(recId)
        return output
    }
    
    /// Converts serialized signature into library's signature format. Use it to supply signature to
    /// the publicKey(signature:hash:) method.
    ///
    /// - Parameter signature: serialized 65-byte signature
    /// - Returns: signature structure
    public func `import`(signature: Data) -> secp256k1_ecdsa_recoverable_signature {
        precondition(signature.count == 65, "Signature must be 65 byte size")
        var sig = secp256k1_ecdsa_recoverable_signature()
        let recId = Int32(signature[64])
        signature.withUnsafeBytes { input -> Void in
            guard let p = input.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ecdsa_recoverable_signature_parse_compact(context, &sig, p, recId)
        }
        return sig
    }
    
    /// Recovers public key from the signature and the hash. Use import(signature:) to convert signature from bytes.
    /// Use export(publicKey:compressed) to convert recovered public key into bytes.
    ///
    /// - Parameters:
    ///   - signature: signature structure
    ///   - hash: 32-byte (256-bit) hash of a message
    /// - Returns: public key structure or nil, if signature invalid
    public func publicKey(signature: inout secp256k1_ecdsa_recoverable_signature, hash: Data) -> secp256k1_pubkey? {
        precondition(hash.count == 32, "Hash must be 32 bytes size")
        let hash = hash.bytes
        var outPubKey = secp256k1_pubkey()
        let status = SecpResult(secp256k1_ecdsa_recover(context, &outPubKey, &signature, hash))
        return status == .success ? outPubKey : nil
    }
    
    /// Converts public key from library's data structure to bytes
    ///
    /// - Parameters:
    ///   - publicKey: public key structure to convert.
    ///   - compressed: whether public key should be compressed.
    /// - Returns: If compression enabled, public key is 33 bytes size, otherwise it is 65 bytes.
    public func export(publicKey: inout secp256k1_pubkey, compressed: Bool) -> Data {
        var output = Data(count: compressed ? 33 : 65)
        var outputLen: Int = output.count
        let compressedFlags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        output.withUnsafeMutableBytes { pointer -> Void in
            guard let p = pointer.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ec_pubkey_serialize(context, p, &outputLen, &publicKey, compressedFlags)
        }
        return output
    }
}
