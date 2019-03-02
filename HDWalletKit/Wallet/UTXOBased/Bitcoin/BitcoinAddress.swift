//
//  BitcoinAddress.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 1/8/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public protocol AddressProtocol {
    var network: BitcoinNetwork { get }
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
    public let network: BitcoinNetwork
    public let type: AddressType
    public let data: Data
    public let base58: Base58Check
    public let cashaddr: String
    public let publicKey: Data?
    
    public typealias Base58Check = String
    
    public init(data: Data, type: AddressType, network: BitcoinNetwork, base58: String, bech32: String, publicKey: Data?) {
        self.data = data
        self.type = type
        self.network = network
        self.base58 = base58
        self.cashaddr = bech32
        self.publicKey = publicKey
    }
    
    public init(_ base58: Base58Check) throws {
        guard let raw = Base58.decode(base58) else {
            throw AddressError.invalid
        }
        let checksum = raw.suffix(4)
        let pubKeyHash = raw.dropLast(4)
        let checksumConfirm = pubKeyHash.doubleSHA256.prefix(4)
        guard checksum == checksumConfirm else {
            throw AddressError.invalid
        }
        
        let network: BitcoinNetwork
        let type: AddressType
        let addressPrefix = pubKeyHash[0]
        switch addressPrefix {
        case BitcoinNetwork.mainnet.pubkeyhash:
            network = .mainnet
            type = .pubkeyHash
        case BitcoinNetwork.mainnet.scripthash:
            network = .mainnet
            type = .scriptHash
        default:
            throw AddressError.invalidVersionByte
        }
        
        self.network = network
        self.type = type
        self.publicKey = nil
        self.data = pubKeyHash.dropFirst()
        self.base58 = base58
        
        // cashaddr
        switch type {
        case .pubkeyHash, .scriptHash:
            let payload = Data([type.versionByte160]) + self.data
            self.cashaddr = Bech32.encode(payload, prefix: network.scheme)
        default:
            self.cashaddr = ""
        }
    }
    public init(data: Data, type: AddressType, network: BitcoinNetwork) {
        let addressData: Data = [type.versionByte] + data
        self.data = data
        self.type = type
        self.network = network
        self.publicKey = nil
        self.base58 = publicKeyHashToAddress(addressData)
        self.cashaddr = Bech32.encode(addressData, prefix: network.scheme)
    }
}

extension LegacyAddress: Equatable {
    public static func == (lhs: LegacyAddress, rhs: LegacyAddress) -> Bool {
        return lhs.network == rhs.network && lhs.data == rhs.data && lhs.type == rhs.type
    }
}

extension LegacyAddress: CustomStringConvertible {
    public var description: String {
        return base58
    }
}

public struct Cashaddr: Address {
    public let network: BitcoinNetwork
    public let type: AddressType
    public let data: Data
    public let base58: String
    public let cashaddr: CashaddrWithScheme
    public let publicKey: Data?
    
    public typealias CashaddrWithScheme = String
    
    public init(data: Data, type: AddressType, network: BitcoinNetwork, base58: String, bech32: CashaddrWithScheme, publicKey: Data?) {
        self.data = data
        self.type = type
        self.network = network
        self.base58 = base58
        self.cashaddr = bech32
        self.publicKey = publicKey
    }
    
    public init(_ cashaddr: CashaddrWithScheme) throws {
        guard let decoded = Bech32.decode(cashaddr) else {
            throw AddressError.invalid
        }
        let (prefix, raw) = (decoded.prefix, decoded.data)
        self.cashaddr = cashaddr
        self.publicKey = nil
        
        switch prefix {
        case BitcoinNetwork.mainnet.scheme:
            network = .mainnet
        case BitcoinNetwork.testnet.scheme:
            network = .testnet
        default:
            throw AddressError.invalidScheme
        }
        
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
            base58 = publicKeyHashToAddress(Data([network.pubkeyhash]) + data)
        case .scriptHash:
            type = .scriptHash
            base58 = publicKeyHashToAddress(Data([network.scripthash]) + data)
        }
    }
    public init(data: Data, type: AddressType, network: BitcoinNetwork) {
        let addressData: Data = [type.versionByte] + data
        self.data = data
        self.type = type
        self.network = network
        self.publicKey = nil
        self.base58 = publicKeyHashToAddress(addressData)
        self.cashaddr = Bech32.encode(addressData, prefix: network.scheme)
    }
}

extension Cashaddr: Equatable {
    public static func == (lhs: Cashaddr, rhs: Cashaddr) -> Bool {
        return lhs.network == rhs.network && lhs.data == rhs.data && lhs.type == rhs.type
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
