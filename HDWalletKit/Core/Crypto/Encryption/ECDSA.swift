//
//  ECDSA.swift
//  ECDSA
//
//  Created by yuzushioh on 2018/01/25.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation
import secp256k1

public final class ECDSA {
    public static let secp256k1 = ECDSA()
    
    public func generatePublicKey(with privateKey: Data, isCompressed: Bool) -> Data {
        return generatePublicKey(privateKeyData: privateKey, isCompression: isCompressed)!
    }
    
    public static func sign(_ data: Data, privateKey: Data) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }
        let status = data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            privateKey.withUnsafeBytes { secp256k1_ecdsa_sign(ctx, signature, ptr, $0, nil, nil) }
        }
        guard status == 1 else { throw HDWalletKitError.failedToSign }
        
        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { normalizedsig.deallocate() }
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)
        
        var length: size_t = 128
        var der = Data(count: length)
        guard der.withUnsafeMutableBytes({ return secp256k1_ecdsa_signature_serialize_der(ctx, $0, &length, normalizedsig) }) == 1 else { throw HDWalletKitError.noEnoughSpace }
        der.count = length
        
        return der
    }
    
    func generatePublicKey(privateKeyData: Data, isCompression: Bool) -> Data? {
        
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        
        let prvKey = privateKeyData.bytes
        var pKey = secp256k1_pubkey()
        
        var result = SecpResult(secp256k1_ec_pubkey_create(context, &pKey, prvKey))
        if result == .failure {
            return nil
        }
        let compressedKeySize = 33
        let decompressedKeySize = 65
        
        let keySize = isCompression ? compressedKeySize : decompressedKeySize
        let serealizedKey = UnsafeMutablePointer<UInt8>.allocate(capacity: keySize)

        var keySizeT = size_t(keySize)
        let copressingKey = isCompression ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        
        result = SecpResult(secp256k1_ec_pubkey_serialize(context,
                                               serealizedKey,
                                               &keySizeT,
                                               &pKey,
                                               copressingKey))
        if result == .failure {
            return nil
        }
        
        secp256k1_context_destroy(context)
        
        let data = Data(bytes: serealizedKey, count: keySize)
        free(serealizedKey)
        return data
    }
    
    public func verifySignature(_ sigData: Data, message: Data, publicKeyData: Data) throws -> Bool {
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY)) else { return false }
        var pubkey = secp256k1_pubkey()
        var signature = secp256k1_ecdsa_signature()
        secp256k1_ecdsa_signature_parse_der(ctx, &signature, sigData.bytes, sigData.count)
        
        if (secp256k1_ec_pubkey_parse(ctx, &pubkey, publicKeyData.bytes, publicKeyData.count) != 1) {
            return false
        };
        
        if (secp256k1_ecdsa_verify(ctx, &signature, message.bytes, &pubkey) != 1) {
            return false
        };
        secp256k1_context_destroy(ctx);
        return true
    }
}
