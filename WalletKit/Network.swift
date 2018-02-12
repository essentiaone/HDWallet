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
    
    public var publicKeyHash: UInt8 {
        switch self {
        case .main:
            return 0x00
        case .test:
            return 0x6f
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
