//
//  KeystoreV3Json.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 19.08.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public struct KeystoreParamsV3: Codable {
    var crypto: CryptoParamsV3
    var id: String?
    var version: Int
    
    public init(crypto cr: KeystoreParamsV3.CryptoParamsV3, id i: String, version ver: Int) {
        crypto = cr
        id = i
        version = ver
    }
    
    public struct CryptoParamsV3: Codable {
        var ciphertext: String
        var cipher: String
        var cipherparams: CipherParamsV3
        var kdf: String
        var kdfparams: KdfParamsV3
        var mac: String
        var version: String?
        
        public struct KdfParamsV3: Codable {
            var salt: String
            var dklen: Int
            var n: Int?
            var p: Int?
            var r: Int?
        }
        
        public struct CipherParamsV3: Codable {
            var iv: String
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case crypto = "Crypto"
        case id, version
    }
}
