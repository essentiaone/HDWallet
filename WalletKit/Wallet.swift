//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public final class Wallet {
    public let privateKey: PrivateKey
    public let publicKey: PublicKey
    public let network: Network
    
    public init(seed: Data, network: Network) {
        self.network = network
        privateKey = PrivateKey(seed: seed, network: network)
        publicKey = privateKey.publicKey
    }
    
    private var changePrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 44, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let change = account.derived(at: 0)
        return change
    }
    
    public func generateAddress(at index: UInt32) -> String {
        print(changePrivateKey.extended)
        return changePrivateKey.derived(at: index).publicKey.address
    }
}
