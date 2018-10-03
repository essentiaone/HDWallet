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
        default:
            return 0x0488ADE4
        }
    }
    
    public var publicKeyVersion: UInt32 {
        switch self {
        case .litecoin:
            return 0x019DA462
        default:
            return 0x0488B21E
        }
    }
    
    public var publicKeyHash: UInt8 {
        switch self {
        case .litecoin:
            return 0x30
        default:
            return 0x00
        }
    }
    
    //https://www.reddit.com/r/litecoin/comments/6vc8tc/how_do_i_convert_a_raw_private_key_to_wif_for/
    public var wifPreifx: UInt8 {
        switch self {
        case .litecoin:
            return 0xB0
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
    
    
    public var coinType: UInt32 {
        switch self {
        case .bitcoin:
            return 0
        case .ethereum:
            return 60
        case .litecoin:
            return 2
        case .bitcoinCash:
            return 145
        }
    }
}
