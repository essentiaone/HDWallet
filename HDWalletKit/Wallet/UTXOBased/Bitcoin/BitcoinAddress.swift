//
//  BitcoinAddress.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 1/8/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public enum AddressType {
    case pubkeyHash
    case scriptHash
    case wif
}

public protocol AddressProtocol {
    var coin: Coin { get }
    var type: AddressType { get }
    var data: Data { get }
    var publicKey: Data? { get }
    
    var base58: String { get }
    var cashaddr: String { get }
}

public typealias Address = AddressProtocol

public enum AddressError: Error {
    case invalid
    case invalidScheme
    case invalidVersionByte
}

public struct LegacyAddress: Address {
    public let coin: Coin
    public let type: AddressType
    public let data: Data
    public let base58: Base58Check
    public let cashaddr: String
    public let publicKey: Data?
    
    public typealias Base58Check = String
    
    public init(_ base58: Base58Check, coin: Coin) throws {
        guard let raw = Base58.decode(base58) else {
            throw AddressError.invalid
        }
        let checksum = raw.suffix(4)
        let pubKeyHash = raw.dropLast(4)
        let checksumConfirm = pubKeyHash.doubleSHA256.prefix(4)
        guard checksum == checksumConfirm else {
            throw AddressError.invalid
        }
        self.coin = coin
        
        let type: AddressType
        let addressPrefix = pubKeyHash[0]
        switch addressPrefix {
        case coin.publicKeyHash:
            type = .pubkeyHash
        case coin.wifAddressPrefix:
            type = .wif
        default:
            throw AddressError.invalidVersionByte
        }
        
        self.type = type
        self.publicKey = nil
        self.data = pubKeyHash.dropFirst()
        self.base58 = base58
        
        // cashaddr
        switch type {
        case .pubkeyHash:
            let payload = Data([coin.publicKeyHash]) + self.data
            self.cashaddr = Bech32.encode(payload, prefix: coin.scheme)
        case .wif:
            let payload = Data([coin.wifAddressPrefix]) + self.data
            self.cashaddr = Bech32.encode(payload, prefix: coin.scheme)
        default:
            self.cashaddr = ""
        }
    }
}

extension LegacyAddress: Equatable {
    public static func == (lhs: LegacyAddress, rhs: LegacyAddress) -> Bool {
        return lhs.coin == rhs.coin && lhs.data == rhs.data && lhs.type == rhs.type
    }
}

extension LegacyAddress: CustomStringConvertible {
    public var description: String {
        return base58
    }
}
