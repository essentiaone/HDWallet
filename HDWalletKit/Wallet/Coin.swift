//
//  Coin.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public enum Coin {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    
    //https://github.com/satoshilabs/slips/blob/master/slip-0132.md
    public var privateKeyVersion: UInt32 {
        switch self {
        case .litecoin:
            return 0x019D9CFE
        case .bitcoin:
            return 0x0488ADE4
        default:
            return 0x0488ADE4
        }
    }
    
    public var publicKeyVersion: UInt32 {
        switch self {
        case .litecoin:
            return 0x019DA462
        case .bitcoin:
            return 0x0488B21E
        default:
            return 0x0488B21E
        }
    }
    
    public var publicKeyHash: UInt8 {
        switch self {
        case .litecoin:
            return 0x30
        case .bitcoin:
            return 0x00
        default:
            return 0x00
        }
    }
    
    //https://www.reddit.com/r/litecoin/comments/6vc8tc/how_do_i_convert_a_raw_private_key_to_wif_for/
    public var wifPrefix: UInt8 {
        switch self {
        case .litecoin:
            return 0xB0
        case .bitcoin:
            return 0x80
        default:
            return 0x80
        }
    }
    
    public var scripthash: UInt8 {
        switch self {
        case .litecoin:
            return 0xB0
        case .bitcoin:
            return 0x80
        default:
            return 0x80
        }
    }
    
    public var addressPrefix:String {
        switch self {
        case .ethereum:
            return "0x"
        default:
            return ""
        }
    }
    
    public var uncompressedPkSuffix: UInt8 {
        return 0x01
    }
    
    
    public var coinType: UInt32 {
        switch self {
        case .bitcoin:
            return 0
        case .litecoin:
            return 2
        case .ethereum:
            return 60
        case .bitcoinCash:
            return 145
        }
    }
    
    public var scheme: String {
        switch self {
        case .bitcoin:
            return "bitcoin"
        case .litecoin:
            return "litecoin"
        case .bitcoinCash:
            return "bitcoincash"
        default: return ""
        }
    }
}
