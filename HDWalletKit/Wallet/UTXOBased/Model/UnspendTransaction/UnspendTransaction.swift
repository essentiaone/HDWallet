//
//  UnspendTransaction.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public struct UnspentTransaction {
    public let output: TransactionOutput
    public let outpoint: TransactionOutPoint
    
    public init(output: TransactionOutput, outpoint: TransactionOutPoint) {
        self.output = output
        self.outpoint = outpoint
    }
}
