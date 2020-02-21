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
        let pk = PrivateKey(pk: "L5GgBH1U8PuNuzCQGvvEH3udEXCEuJaiK96e88romhpGa1cU7JTY", coin: .bitcoin)!
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
    
    func testBitcoinCashSign() {
        let pk = PrivateKey(pk: "KwgDcj2ZDN5vzRXsTv1F6vzQV7nx7shEYjFBcWng1sH6Fy9rhK2b", coin: .bitcoinCash)!
        let lockingScript: Data = Data(hex: "76a914e42a54ba2042e889461c7966ac6ba13eeb144a3f88ac")
        let txidData: Data = Data(hex: "9ced8296cf15e67295a99aa0389229e27eae571436925db587665ba02210bcf3")
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: 524839, lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: 352337565)
        let utxo = UnspentTransaction(output: output, outpoint: outpoint)
        let address = try! LegacyAddress("1HLqrFX5fYwKriU7LRKMQGhwpz5HuszjnK", coin: .bitcoinCash)
        let utxoWallet = UTXOWallet(privateKey: pk)
        do {
            let signedTx = try utxoWallet.createTransaction(to: address, amount: 10000, utxos: [utxo])
            XCTAssertEqual(signedTx, "0100000001f3bc1022a05b6687b55d92361457ae7ee2299238a09aa99572e615cf9682ed9c9d3e00156a473044022013373441cc4521f4c4d89b454520ebedaebe4e035b5e1f9575886f1eaad4e91302200af1062f4c4e8c0633b9e3570f1d399af3f04d5ca5806bb9d62a162dfba9a2b64121030f6c58f37ffe1bf56dd79fac07f339f44d96efaa3d78e1f32fadd41dcd0b7bbcffffffff0210270000000000001976a914b342b16a24dffc3be74ccf202e418fc22c271cbd88ac35da0700000000001976a9149f902c3c088cc352eae162bcb8fb0540b47c971188ac00000000")
        } catch {
            print(error)
        }
    }
    
    
    func testDashSign() {
        let pk = PrivateKey(pk: "XJpB8Kdaws3YzzS4dfLBhoUmyrzMkVp3KxKg1deiHk9dnLwZYPcA", coin: .dash)!
        let lockingScript: Data = Data(hex: "76a914e42a54ba2042e889461c7966ac6ba13eeb144a3f88ac")
        let txidData: Data = Data(hex: "9ced8296cf15e67295a99aa0389229e27eae571436925db587665ba02210bcf3")
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: 524839, lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: 352337565)
        let utxo = UnspentTransaction(output: output, outpoint: outpoint)
        let address = try! LegacyAddress("Xud1fZjupDuhndpYtTquDPmSWmehtEbxhy", coin: .dash)
        let utxoWallet = UTXOWallet(privateKey: pk)
        do {
            let signedTx = try utxoWallet.createTransaction(to: address, amount: 10000, utxos: [utxo])
            XCTAssertEqual(signedTx, "0100000001f3bc1022a05b6687b55d92361457ae7ee2299238a09aa99572e615cf9682ed9c9d3e00156a47304402202a7aaddeb07faf748ef48ffeccb0c61ee87840a468ead1dd8e4b6aa9003527470220143f1c6429662da1f0906b43bda82d1fa8c76711256502c1d08b8f9be43a42270121035d72ea3bae4502aadb86a7ab678004585ab9b27e12bbf01d13f514f9159f8adfffffffff0210270000000000001976a914cfb0ef26fa554125f6dbae9762f9b914bc823bc388ac35da0700000000001976a914553869406141a4145ed9050737266c4a4790b2b088ac00000000")
        } catch {
            print(error)
        }
    }
    
    func testRawTransactionCration() {
        let pk = PrivateKey(pk: "L5VqJYoBWVKwe3icNjSGz5maPmAaSm32TEjPdxMNyix8groNubU8", coin: .bitcoin)!
        print(pk.publicKey.address)
    }
}
