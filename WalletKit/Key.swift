//
//  Key.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public struct Key {
    public let version: UInt32
    public let depth: UInt32
    public let fingurePrint: UInt32
    public let index: UInt32
    public let privateKey: Data
    public let chainCode: Data
    
    public init(privateKey: Data, chainCode: Data, network: Network) {
        self.version = network.version
        self.depth = 0
        self.fingurePrint = 0
        self.index = 0
        self.privateKey = privateKey
        self.chainCode = chainCode
    }
    
    public var extendedPrivateKey: String {
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    private var extendedPrivateKeyData: Data {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += version.toHexData
        extendedPrivateKeyData += depth.toHexData
        extendedPrivateKeyData += fingurePrint.toHexData
        extendedPrivateKeyData += index.toHexData
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0).toHexData
        extendedPrivateKeyData += privateKey
        return extendedPrivateKeyData
    }
}
