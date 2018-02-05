//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation
import CryptoSwift

public final class Wallet {
    public let masterKeyPair: KeyPair
    public let network: Network
    
    public init(seed: String, network: Network) {
        let seed = seed.mnemonicData
        let output: [UInt8]
        do {
            output = try HMAC(key: "Bitcoin seed", variant: .sha512).authenticate(seed.bytes)
        } catch let error {
            fatalError("Error occured in SeedAuthenticator. Description: \(error.localizedDescription)")
        }
        
        self.network = network
        self.masterKeyPair = KeyPair(
            privateKeyData: Data(output[0..<32]),
            chainCodeData: Data(output[32..<64]),
            network: network
        )
    }
}
