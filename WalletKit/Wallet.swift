//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public final class Wallet {
    private let keyGenerator: KeyGenerator
    
    public init(network: Network) {
        keyGenerator = KeyGenerator(seedString: "000102030405060708090a0b0c0d0e0f", network: network)
    }
}
