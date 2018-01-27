//
//  KeyPairGeneratorType.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public protocol KeyPairGeneratorType {
    
    /// KeyPair with MasterPrivateKey and MasterPublicKey generated from seed you provided.
    static var masterKeyPair: KeyPair? { get }
    
    /// Set up KeyGenerator. Before initializing KeyGenerator, you need to call this method to generate master key pair. Otherwise crashes.
    ///
    /// - Parameters:
    ///   - seedString: Root seed for generating HD wallet.
    ///   - network: Netwrok indicating whether it is for test net or main net.
    ///   - hardensMasterKeyPair: whether or not you want the keys to be hardened.
    static func setup(seedString: String, network: Network, hardensMasterKeyPair: Bool)
}
