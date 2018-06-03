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
    
    func generatePublicKey(privateKeyData: Data, isCompression: Bool) -> Data? {
        
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        
        let prvKey = privateKeyData.bytes
        var pKey = secp256k1_pubkey()
        
        var result = secp256k1_ec_pubkey_create(context, &pKey, prvKey)
        if (result != 1) {
            return nil
        }
        
        let size = isCompression ? 33 : 65
        let pubkey = UnsafeMutablePointer<UInt8>.allocate(capacity: size)

        var s = size_t()
        
        result = secp256k1_ec_pubkey_serialize(context, pubkey, &s, &pKey, isCompression ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED))
        if (result != 1) {
            return nil
        }
        
        secp256k1_context_destroy(context);
        
        let data = Data(bytes: pubkey, count: size)
        free(pubkey)
        return data
    }
}
