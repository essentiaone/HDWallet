//
//  UnsignedTransaction.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/17/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct UnsignedTransaction {
    public let tx: Transaction
    public let utxos: [UnspentTransaction]
    
    public init(tx: Transaction, utxos: [UnspentTransaction]) {
        self.tx = tx
        self.utxos = utxos
    }
}
