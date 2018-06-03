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
    public let publicKey: PublicKey
    public let network: Network
    
    public init(seed: Data, network: Network) {
        self.network = network
        privateKey = PrivateKey(seed: seed, network: network)
        publicKey = privateKey.publicKey
    }
    
    private var receivePrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 44, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let receive = account.derived(at: 0)
        return receive
    }
    
    private var changePrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 44, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let change = account.derived(at: 1)
        return change
    }

    private var receiveBIP49PrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 49, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let receive = account.derived(at: 0)
        return receive
    }
    
    private var changeBIP49PrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 49, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let change = account.derived(at: 1)
        return change
    }
    
    private var receiveBIP84PrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 84, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let receive = account.derived(at: 0)
        return receive
    }
    
    private var changeBIP84PrivateKey: PrivateKey {
        let purpose = privateKey.derived(at: 84, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        let change = account.derived(at: 1)
        return change
    }
    
    public func generateAddress(at index: UInt32) -> String {
        return receivePrivateKey.derived(at: index).publicKey.address
    }
    
    public func generateAddressBIP49(at index: UInt32) -> String {
        return receiveBIP49PrivateKey.derived(at: index).publicKey.addressBIP49
    }
    
    public func generateAddressBIP84(at index: UInt32) -> String {
        return receiveBIP84PrivateKey.derived(at: index).publicKey.addressBIP84
    }
}
