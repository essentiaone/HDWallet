//
//  Key.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public struct Key {
    private let version: UInt32
    private let depth: UInt8
    private let fingurePrint: UInt32
    private let index: UInt32
    private let privateKey: Data
    private let chainCode: Data
    
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
