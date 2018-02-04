//
//  KeyPairGenerator.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import CryptoSwift

public final class KeyPairGenerator: KeyPairGeneratorType {
    
    public static var masterKeyPair: KeyPair?
    
    public static func setup(seedString: String, network: Network, hardensMasterKeyPair: Bool) {
        let seed = seedString.mnemonicData
        let output: [UInt8]
        do {
            output = try HMAC(key: "Bitcoin seed", variant: .sha512).authenticate(seed.bytes)
        } catch let error {
            fatalError("Error occured in SeedAuthenticator. Description: \(error.localizedDescription)")
        }
        
        masterKeyPair = KeyPair(
            privateKeyData: Data(output[0..<32]),
            chainCodeData: Data(output[32..<64]),
            hardens: hardensMasterKeyPair,
            network: network
        )
    }
    
    public init() {
        guard let masterKeyPair = KeyPairGenerator.masterKeyPair else {
            fatalError("\(KeyPairGenerator.setup) must be called before initializing.")
        }
        
        print(
            masterKeyPair.extendedPrivateKey,
            masterKeyPair.extendedPublicKey
        )
        
        let key = masterKeyPair.derive(at: "m/44'/0'/0'/0")
        print(key.extendedPrivateKey, key.extendedPublicKey)
    }
}
