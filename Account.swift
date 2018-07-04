//
//  Account.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 04.07.18.
//

import Foundation

public struct Account:Equatable {
    
    public init(rawPrivateKey:String, rawPublicKey:String, address:String) {
        self.rawPublicKey = rawPublicKey
        self.rawPrivateKey = rawPrivateKey
        self.address = address
    }
    
    public let rawPrivateKey: String
    public let rawPublicKey: String
    public let address: String
}
