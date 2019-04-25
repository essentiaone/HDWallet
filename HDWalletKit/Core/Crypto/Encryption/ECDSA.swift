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
    
    public static func sign(_ data: Data, privateKey: Data) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }

        data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            guard let dataPointer = ptr.bindMemory(to: UInt8.self).baseAddress else { return }
            privateKey.withUnsafeBytes { (pkPtr: UnsafeRawBufferPointer) in
                guard let privateKeyPointer = pkPtr.bindMemory(to: UInt8.self).baseAddress else { return }
                secp256k1_ecdsa_sign(ctx, signature, dataPointer, privateKeyPointer, nil, nil)
            }
        }
        
        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { normalizedsig.deallocate() }
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)
        
        var length: size_t = 128
        var der = Data(count: length)
        der.withUnsafeMutableBytes({ (ptr: UnsafeMutableRawBufferPointer) -> Void in
            guard let pointer = ptr.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ecdsa_signature_serialize_der(ctx, pointer, &length, normalizedsig)
        })
        der.count = length
        
        return der
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
