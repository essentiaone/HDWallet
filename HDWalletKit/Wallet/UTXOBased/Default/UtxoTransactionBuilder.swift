//
//  UtxoTransactionBuilder.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/17/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct UtxoTransactionBuilder: UtxoTransactionBuilderInterface {
    public init() {}
    public func build(destinations: [(address: Address, amount: UInt64)], utxos: [UnspentTransaction]) throws -> UnsignedTransaction {
        let outputs = try destinations.map { (address: Address, amount: UInt64) -> TransactionOutput in
            guard let lockingScript = Script(address: address)?.data else {
                throw TransactionBuildError.error("Invalid address type")
            }
            return TransactionOutput(value: amount, lockingScript: lockingScript)
        }
        
        let unsignedInputs = utxos.map { TransactionInput(previousOutput: $0.outpoint, signatureScript: $0.output.lockingScript, sequence: UInt32.max) }
        let tx = Transaction(version: 1, inputs: unsignedInputs, outputs: outputs, lockTime: 0)
        return UnsignedTransaction(tx: tx, utxos: utxos)
    }
}

enum TransactionBuildError: Error {
    case error(String)
}
