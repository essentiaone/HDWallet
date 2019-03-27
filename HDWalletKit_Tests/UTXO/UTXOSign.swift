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
            let signedTx = try utxoWallet.createTransaction(to: address, amount: 10000, utxos: [utxo])
            XCTAssertEqual(signedTx, "0100000001f3bc1022a05b6687b55d92361457ae7ee2299238a09aa99572e615cf9682ed9c9d3e00156b483045022100e1283f8ac9d00d4a393f5629db9df867a1702da309a9125746f2a332c21038d20220015baf4d864254f47f08140853dd58b78f9df1749ff0e2b81ac5a9f6345b987e01210346a4129884b46fdb7f7977c6e90ed4c367af343494f3ff5272db721752d28ef3ffffffff0210270000000000001976a914b342b16a24dffc3be74ccf202e418fc22c271cbd88ac35da0700000000001976a9144f5cd7cf2e4d0ec1bcbd82b64691e2f7867b618688ac00000000")
        } catch {
            print(error)
        }
    }
    
    func testRawTransactionCration() {
        let pk = PrivateKey(pk: "L5VqJYoBWVKwe3icNjSGz5maPmAaSm32TEjPdxMNyix8groNubU8", coin: .bitcoin)
        print(pk.publicKey.address)
    }
}
