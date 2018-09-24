//
//  Crypto.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import CryptoSwift

public final class Crypto {
   public static func HMACSHA512(key: Data, data: Data) -> Data {
        let output: [UInt8]
        do {
            output = try HMAC(key: key.bytes, variant: .sha512).authenticate(data.bytes)
        } catch let error {
            fatalError("Error occured. Description: \(error.localizedDescription)")
        }
        return Data(output)
    }
    
    public static func PBKDF2SHA512(password: [UInt8], salt: [UInt8]) -> Data {
        let output: [UInt8]
        do {
            output = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, variant: .sha512).calculate()
        } catch let error {
            fatalError("PKCS5.PBKDF2 faild: \(error.localizedDescription)")
        }
        return Data(output)
    }
    
    public static func generatePublicKey(data: Data, compressed: Bool) -> Data {
        return ECDSA.secp256k1.generatePublicKey(with: data, isCompressed: compressed)
    }
    
    public static func sha3keccak256(data:Data) -> Data {
        return Data(bytes: SHA3(variant: .keccak256).calculate(for: data.bytes))
    }
    
    public static func hashSHA3_256(_ data: Data) -> Data {
        return Data(bytes: CryptoSwift.SHA3(variant: .sha256).calculate(for: data.bytes))
    }
    
    public static func sign(_ hash: Data, privateKey: Data) throws -> Data {
        let encrypter = EllipticCurveEncrypterSecp256k1()
        guard var signatureInInternalFormat = encrypter.sign(hash: hash, privateKey: privateKey) else {
            throw HDWalletKitError.failedToSign
        }
        return encrypter.export(signature: &signatureInInternalFormat)
    }
}

// MARK: SHA256 of SHA256
extension Data {
    var doubleSHA256: Data {
        return sha256().sha256()
    }
}

