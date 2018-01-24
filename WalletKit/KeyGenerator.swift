//
//  KeyGenerator.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import CryptoSwift

public final class KeyGenerator: KeyGeneratorType {
    
    public let masterPrivateKey: Key
    
    public init(seedString: String, network: Network) {
        let seed = seedString.mnemonicData
        let output: [UInt8]
        do {
            output = try HMAC(key: "Bitcoin seed", variant: .sha512).authenticate(seed.bytes)
        } catch let error {
            fatalError("Error occured in SeedAuthenticator. Description: \(error.localizedDescription)")
        }
        
        masterPrivateKey = Key(
            privateKey: Data(output[0..<32]),
            chainCode: Data(output[32..<64]),
            network: network
        )
    }
}
