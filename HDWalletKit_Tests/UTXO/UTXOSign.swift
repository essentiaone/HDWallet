//
//  UTXOSign.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 3/26/19.
//  Copyright © 2019 Essentia. All rights reserved.
//


import XCTest
@testable import HDWalletKit

class UTXOSign: XCTestCase {
    func testBitcoinSign() {
        let pk = PrivateKey(pk: "L5GgBH1U8PuNuzCQGvvEH3udEXCEuJaiK96e88romhpGa1cU7JTY", coin: .bitcoin)
        let lockingScript: Data = Data(hex: "76a914e42a54ba2042e889461c7966ac6ba13eeb144a3f88ac")
        let txidData: Data = Data(hex: "9ced8296cf15e67295a99aa0389229e27eae571436925db587665ba02210bcf3")
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: 524839, lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: 352337565)
        let utxo = UnspentTransaction(output: output, outpoint: outpoint)
        let address = try! LegacyAddress("1HLqrFX5fYwKriU7LRKMQGhwpz5HuszjnK", coin: .bitcoin)
        let utxoWallet = UTXOWallet(privateKey: pk)
        do {
            let signedTx = try utxoWallet.createTransaction(to: address, amount: 0, utxos: [utxo])
            XCTAssertEqual(signedTx, "01000000000200000000000000001976a914b342b16a24dffc3be74ccf202e418fc22c271cbd88ac00000000000000001976a9144f5cd7cf2e4d0ec1bcbd82b64691e2f7867b618688ac00000000")
            
        } catch {
            print(error)
        }
    }
    
    func testRawTransactionCration() {
//        let pk = PrivateKey(pk: "<#T##String#>", coin: <#T##Coin#>)
    }
}
