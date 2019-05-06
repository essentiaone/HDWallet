//
//  UTXOWallet.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

final public class UTXOWallet {
    public let privateKey: PrivateKey
    
    private let utxoSelector: UtxoSelectorInterface
    private let utxoTransactionBuilder: UtxoTransactionBuilderInterface
    private let utoxTransactionSigner: UtxoTransactionSignerInterface
    
    public convenience init(privateKey: PrivateKey) {
        switch privateKey.coin {
        case .bitcoin, .litecoin, .dash, .bitcoinCash:
            self.init(privateKey: privateKey,
                      utxoSelector: UtxoSelector(),
                      utxoTransactionBuilder: UtxoTransactionBuilder(),
                      utoxTransactionSigner: UtxoTransactionSigner())
        default:
            fatalError("Coin not supported yet")
        }
    }
    
    public init(privateKey: PrivateKey,
                utxoSelector: UtxoSelectorInterface,
                utxoTransactionBuilder: UtxoTransactionBuilderInterface,
                utoxTransactionSigner: UtxoTransactionSignerInterface) {
        self.privateKey = privateKey
        self.utxoSelector = utxoSelector
        self.utxoTransactionBuilder = utxoTransactionBuilder
        self.utoxTransactionSigner = utoxTransactionSigner
    }
    
    public func createTransaction(to toAddress: Address, amount: UInt64, utxos: [UnspentTransaction]) throws -> String {
        let (utxosToSpend, fee) = try self.utxoSelector.select(from: utxos, targetValue: amount)
        let totalAmount: UInt64 = utxosToSpend.sum()
        let change: UInt64 = totalAmount - amount - fee
        let destinations: [(Address, UInt64)] = [(toAddress, amount), (privateKey.publicKey.utxoAddress, change)]
        let unsignedTx = try self.utxoTransactionBuilder.build(destinations: destinations, utxos: utxosToSpend)
        let signedTx = try self.utoxTransactionSigner.sign(unsignedTx, with: self.privateKey)
        return signedTx.serialized().hex
    }
}
