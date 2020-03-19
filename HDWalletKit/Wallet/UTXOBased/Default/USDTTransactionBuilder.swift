//
//  USDTTransactionBuilder.swift
//  HDWalletKit
//
//  Created by Jax on 2019/10/24.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public struct USDTTransactionBuilder: UtxoTransactionBuilderInterface {
    public init(usdtLockingScript: Data) {
        self.usdtLockingScript = usdtLockingScript
    }

    private let usdtLockingScript: Data

    public func build(destinations: [(address: Address, amount: UInt64)], utxos: [UnspentTransaction]) throws -> UnsignedTransaction {
        var outputs = try destinations.map { (address: Address, amount: UInt64) -> TransactionOutput in
            guard let lockingScript = Script(address: address)?.data else {
                throw TransactionBuildError.error("Invalid address type")
            }
            return TransactionOutput(value: amount, lockingScript: lockingScript)
        }
        let usdtTxOutput = TransactionOutput(value: 0, lockingScript: usdtLockingScript)
        outputs.append(usdtTxOutput) // add a new script output

        let unsignedInputs = utxos.map { TransactionInput(previousOutput: $0.outpoint, signatureScript: $0.output.lockingScript, sequence: UInt32.max) }
        let tx = Transaction(version: 1, inputs: unsignedInputs, outputs: outputs, lockTime: 0)
        return UnsignedTransaction(tx: tx, utxos: utxos)
    }
}

//    static func generateUSDTLockingScript(amountInUSDT: Double) -> Data {
//
//        var usdtData = Data()
//        usdtData += [0x6A, 0x14] // OP_RETURN
//        usdtData += [0x6F, 0x6D, 0x6E, 0x69] // OMNI
//        usdtData += [0x00, 0x00] // Transaction version
//        usdtData += [0x00, 0x00] // Transaction type
//        usdtData += [0x00, 0x00, 0x00, 0x1F] // Currency identifier
//
//        //
//        let converter = BitcoinConverter(bitcoinString: "\(amountInUSDT)")
//        let amountInSatoshi = converter.inSatoshi
//        usdtData += amountInSatoshi.littleEndianData
//
//        return usdtData
//    }
