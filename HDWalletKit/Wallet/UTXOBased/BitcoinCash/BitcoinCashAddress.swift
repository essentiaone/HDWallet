//
//  BitcoinCashAddress.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 5/1/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct BitcoinCashAddress: Address {
    public let coin: Coin
    public let type: AddressType
    public let data: Data
    public let base58: String
    public let cashaddr: String
    
    public init(_ cashaddr: String) throws {
        guard let decoded = Bech32.decode(cashaddr) else {
            throw AddressError.invalid
        }
        
        let raw = decoded.data
        self.cashaddr = cashaddr
        self.coin = .bitcoinCash
        
        let versionByte = raw[0]
        let hash = raw.dropFirst()
        
        guard hash.count == BitcoinCashVersionByte.getSize(from: versionByte) else {
            throw AddressError.invalidVersionByte
        }
        self.data = hash
        guard let typeBits = BitcoinCashVersionByte.TypeBits(rawValue: (versionByte & 0b01111000)) else {
            throw AddressError.invalidVersionByte
        }
        
        switch typeBits {
        case .pubkeyHash:
            type = .pubkeyHash
            base58 = publicKeyHashToAddress(Data([coin.publicKeyHash]) + data)
        case .scriptHash:
            type = .scriptHash
            base58 = publicKeyHashToAddress(Data([coin.scriptHash]) + data)
        }
    }
}
func publicKeyHashToAddress(_ hash: Data) -> String {
    let checksum =  hash.doubleSHA256.prefix(4)
    let address = Base58.encode(hash + checksum)
    return address
}
