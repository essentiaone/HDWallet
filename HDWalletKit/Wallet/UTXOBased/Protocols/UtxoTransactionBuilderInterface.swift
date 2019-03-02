//
//  UtxoTransactionBuilder.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public protocol UtxoTransactionBuilderInterface {
    func build(destinations: [(address: Address, amount: UInt64)], utxos: [UnspentTransaction]) throws -> UnsignedTransaction
}
