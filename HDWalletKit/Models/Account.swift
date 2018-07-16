//
//  Account.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 04.07.18.
//

import Foundation

public struct Account {
    
    public init(privateKey: PrivateKey) {
        self.privateKey = privateKey
    }
    
    public let privateKey: PrivateKey
    
    public var rawPrivateKey: String {
        return privateKey.get()
    }
    
    public var rawPublicKey: String {
        return privateKey.publicKey.get()
    }
    
    public var address: String {
        return privateKey.publicKey.address
    }
}
