//
//  Network.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public enum Network {
    case main
    case test

    public var privateKeyVersion: UInt32 {
        switch self {
        case .main:
            return 0x0488ADE4
        case .test:
            return 0x04358394
        }
    }
    
    public var publicKeyVersion: UInt32 {
        switch self {
        case .main:
            return 0x0488B21E
        case .test:
            return 0x043587CF
        }
    }
    
    public var privateKeyBIP49Version: UInt32 {
        switch self {
        case .main:
            return 0x049D7878
        case .test:
            return 0x044A4E28
        }
    }
    
    public var publicKeyBIP49Version: UInt32 {
        switch self {
        case .main:
            return 0x049D7CB2
        case .test:
            return 0x044A5262
        }
    }

    public var privateKeyBIP84Version: UInt32 {
        switch self {
        case .main:
            return 0x04B2430C
        case .test:
            return 0x045F18BC
        }
    }
    
    public var publicKeyBIP84Version: UInt32 {
        switch self {
        case .main:
            return 0x04B24746
        case .test:
            return 0x045F1CF6
        }
    }
    
    public var publicKeyHash: UInt8 {
        switch self {
        case .main:
            return 0x00
        case .test:
            return 0x6f
        }
    }
    
    public var scriptHash: UInt8 {
        switch self {
        case .main:
            return 0x05
        case .test:
            return 0xc4
        }
    }
    
    public var bech32: String {
        switch self {
        case .main:
            return "bc"
        case .test:
            return "tb"
        }
    }
    
    public var coinType: UInt32 {
        switch self {
        case .main:
            return 0
        case .test:
            return 1
        }
    }
}
