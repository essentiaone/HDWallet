//
//  BitcoinTransactionOutPoint.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation
import CryptoSwift

public struct TransactionOutPoint {
    /// The hash of the referenced transaction.
    public let hash: Data
    /// The index of the specific output in the transaction. The first output is 0, etc.
    public let index: UInt32
    
    public init(hash: Data, index: UInt32) {
        self.hash = hash
        self.index = index
    }
    
    public func serialized() -> Data {
        var data = Data()
        data += hash
        data += index
        return data
    }
    
    static func deserialize(_ byteStream: ByteStream) -> TransactionOutPoint {
        let hash = Data(byteStream.read(Data.self, count: 32))
        let index = byteStream.read(UInt32.self)
        return TransactionOutPoint(hash: hash, index: index)
    }
}

