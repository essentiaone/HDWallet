//
//  KeyGenerator.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation
import CryptoSwift

public final class KeyGenerator: KeyGeneratorType {
    private let privateKey: Data
    private let chainCode: Data
    
    public init(seedString: String, network: Network) {
        let seed = seedString.mnemonicData
        let output: [UInt8]
        do {
            output = try HMAC(key: "Bitcoin", variant: .sha512).authenticate(seed.bytes)
        } catch let error {
            fatalError("Error occured in SeedAuthenticator. Description: \(error.localizedDescription)")
        }
        
        self.privateKey = Data(output[0..<32])
        self.chainCode = Data(output[32..<64])
    }
}
