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
    
    public init(data: Data, type: AddressType, coin: Coin, base58: String, bech32: String, publicKey: Data?) {
        self.data = data
        self.type = type
        self.coin = coin
        self.base58 = base58
        self.cashaddr = bech32
        self.publicKey = publicKey
    }
    
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
        case coin.scripthash:
            type = .scriptHash
        case coin.wifPrefix:
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
        case .scriptHash:
            let payload = Data([coin.scripthash]) + self.data
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

public struct Cashaddr: Address {
    public let coin: Coin
    public let type: AddressType
    public let data: Data
    public let base58: String
    public let cashaddr: CashaddrWithScheme
    public let publicKey: Data?
    
    public typealias CashaddrWithScheme = String
    
    public init(data: Data, type: AddressType, coin: Coin, base58: String, bech32: CashaddrWithScheme, publicKey: Data?) {
        self.data = data
        self.type = type
        self.coin = coin
        self.base58 = base58
        self.cashaddr = bech32
        self.publicKey = publicKey
    }
    
    public init(_ cashaddr: CashaddrWithScheme, coin: Coin) throws {
        guard let decoded = Bech32.decode(cashaddr) else {
            throw AddressError.invalid
        }
        let raw = decoded.data
        self.cashaddr = cashaddr
        self.publicKey = nil
        self.coin = coin
        
        let versionByte = raw[0]
        let hash = raw.dropFirst()
        
        guard hash.count == VersionByte.getSize(from: versionByte) else {
            throw AddressError.invalidVersionByte
        }
        self.data = hash
        guard let typeBits = VersionByte.TypeBits(rawValue: (versionByte & 0b01111000)) else {
            throw AddressError.invalidVersionByte
        }
        
        switch typeBits {
        case .pubkeyHash:
            type = .pubkeyHash
            base58 = publicKeyHashToAddress(Data([coin.publicKeyHash]) + data)
        case .scriptHash:
            type = .scriptHash
            base58 = publicKeyHashToAddress(Data([coin.scripthash]) + data)
        }
    }
}


extension Cashaddr: CustomStringConvertible {
    public var description: String {
        return cashaddr
    }
}

func publicKeyHashToAddress(_ hash: Data) -> String {
    let checksum =  hash.doubleSHA256.prefix(4)
    let address = Base58.encode(hash + checksum)
    return address
}
