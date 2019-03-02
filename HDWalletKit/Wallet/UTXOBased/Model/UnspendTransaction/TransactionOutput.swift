//
//  BitcoinTransactionOutput.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public struct TransactionOutput {
    /// Transaction Value
    public let value: UInt64
    /// Length of the pk_script
    public var scriptLength: VarInt {
        return VarInt(lockingScript.count)
    }
    /// Usually contains the public key as a Bitcoin script setting up conditions to claim this output
    public let lockingScript: Data
    
    public func scriptCode() -> Data {
        var data = Data()
        data += scriptLength.serialized()
        data += lockingScript
        return data
    }
    
    public init(value: UInt64, lockingScript: Data) {
        self.value = value
        self.lockingScript = lockingScript
    }
    
    public init() {
        self.init(value: 0, lockingScript: Data())
    }
    
    public func serialized() -> Data {
        var data = Data()
        data += value
        data += scriptLength.serialized()
        data += lockingScript
        return data
    }
    
    static func deserialize(_ byteStream: ByteStream) -> TransactionOutput {
        let value = byteStream.read(UInt64.self)
        let scriptLength = byteStream.read(VarInt.self)
        let lockingScript = byteStream.read(Data.self, count: Int(scriptLength.underlyingValue))
        return TransactionOutput(value: value, lockingScript: lockingScript)
    }
}
