//
//  UtxoTransactionSigner.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct UtxoTransactionSigner: UtxoTransactionSignerInterface {
    public init() {}
    
    public func sign(_ unsignedTransaction: UnsignedTransaction, with key: PrivateKey) throws -> Transaction {
        // Define Transaction
        var signingInputs: [TransactionInput]
        var signingTransaction: Transaction {
            let tx: Transaction = unsignedTransaction.tx
            return Transaction(version: tx.version, inputs: signingInputs, outputs: tx.outputs, lockTime: tx.lockTime)
        }
        
        // Sign
        signingInputs = unsignedTransaction.tx.inputs
        let hashType = SighashType.hashTypeForCoin(coin: key.coin)
        for (i, utxo) in unsignedTransaction.utxos.enumerated() {
            // Sign transaction hash
            let sighash: Data = signingTransaction.signatureHash(for: utxo.output, inputIndex: i, hashType: hashType)
            let signature: Data = try ECDSA.sign(sighash, privateKey: key.raw)
            let txin = signingInputs[i]
            let pubkey = key.publicKey
            
            // Create Signature Script
            let sigWithHashType: Data = signature + UInt8(hashType)
            let unlockingScript: Script = try Script()
                .appendData(sigWithHashType)
                .appendData(pubkey.data)
            
            // Update TransactionInput
            signingInputs[i] = TransactionInput(previousOutput: txin.previousOutput, signatureScript: unlockingScript.data, sequence: txin.sequence)
        }
        return signingTransaction
        
    }
}
