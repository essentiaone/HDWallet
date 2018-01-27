//
//  KeyGeneratorType.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public protocol KeyGeneratorType {
    
    /// KeyPair with MasterPrivateKey and MasterPublicKey generated from seed you provided.
    var masterKeyPair: KeyPair { get }
    
    /// Initialize KeyGenerator
    ///
    /// - Parameters:
    ///   - seedString: Root seed for generating HD wallet.
    ///   - network: Netwrok indicating whether it is for test net or main net.
    init(seedString: String, network: Network)
}
