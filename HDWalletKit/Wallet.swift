//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//
import Foundation

public final class Wallet {
    public let privateKey: PrivateKey
    public let network: Network
    
    public init(seed: Data, network: Network) {
        self.network = network
        privateKey = PrivateKey(seed: seed, network: network)
    }
    
    public func generatePrivateKey(at nodes:[DerivationNode]) throws -> PrivateKey {
        return try privateKey(at: nodes)
    }
    
    public func generateAddress(at nodes:[DerivationNode]) throws -> String {
        let derivedKey = try privateKey(at: nodes)
        return derivedKey.publicKey.address
    }
    
    private func privateKey(at nodes: [DerivationNode]) throws -> PrivateKey {
        var key: PrivateKey = privateKey
        for node in nodes {
            key = key.derived(at:node)
        }
        return key
    }
}
