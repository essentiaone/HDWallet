//
//  BitcoinTransactionSignatureSerializer.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/5/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct BitcoinTransactionSignatureSerializer {
    var tx: Transaction
    var utxo: TransactionOutput
    var inputIndex: Int
    var hashType: SighashType
    
    // input should be modified before sign
    internal func modifiedInput(for i: Int) -> TransactionInput {
        let txin = tx.inputs[i]
        let sigScript: Data
        let sequence: UInt32
        
        if i == inputIndex {
            let subScript = Script(data: utxo.lockingScript)
            try! subScript?.deleteOccurrences(of: .OP_CODESEPARATOR)
            sigScript = subScript?.data ?? Data()
            sequence = txin.sequence
        } else if hashType.isNone || hashType.isSingle {
            // If hashtype is NONE or SINGLE, blank out others' input sequence numbers to let others update transaction at will.
            sigScript = Data()
            sequence = 0
        } else {
            sigScript = Data()
            sequence = txin.sequence
        }
        return TransactionInput(previousOutput: txin.previousOutput, signatureScript: sigScript, sequence: sequence)
    }
    
    public func serialize() -> Data {
        let inputsToSerialize: [TransactionInput]
        let outputsToSerialize: [TransactionOutput]
        // In case of SIGHASH_ANYONECANPAY, only the input being signed is serialized
        if hashType.isAnyoneCanPay {
            inputsToSerialize = [modifiedInput(for: inputIndex)]
        } else {
            inputsToSerialize = (0..<tx.inputs.count).map { modifiedInput(for: $0) }
        }
        
        if hashType.isNone {
            // Wildcard payee - we can pay anywhere.
            outputsToSerialize = []
        } else if hashType.isSingle {
            // Single mode assumes we sign an output at the same index as an input.
            // All outputs before the one we need are blanked out. All outputs after are simply removed.
            // Only lock-in the txout payee at same index as txin.
            // This is equivalent to replacing outputs with (i-1) empty outputs and a i-th original one.
            let myOutput = tx.outputs[inputIndex]
            outputsToSerialize = Array(repeating: TransactionOutput(), count: inputIndex) + [myOutput]
        } else {
            outputsToSerialize = tx.outputs
        }
        
        let tmp = Transaction(version: tx.version,
                              inputs: inputsToSerialize,
                              outputs: outputsToSerialize,
                              lockTime: tx.lockTime)
        return tmp.serialized()
    }
}
