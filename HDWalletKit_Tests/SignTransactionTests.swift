//
//  SignTransactionTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 20.09.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class SignTransactionTests: XCTestCase {
    
    func testSign() {
        let transaction = EthereumRawTransaction(value: 0x00,
                                                 to: "0x0000000000000000000000000000000000000000",
                                                 gasPrice: 0x09184e72a000,
                                                 gasLimit: 0x2710,
                                                 nonce: 0x00,
                                                 data: Data(hex: "0x7f7465737432000000000000000000000000000000000000000000000000000000600057"))
        let pk = Data(hex: "e331b6d69882b4cb4ea581d88e0b604039a3de5967688d3dcffdd2270c0fd109")
        let data = try! EIP155Signer(chainId: 1).sign(transaction, privateKey: pk);
        XCTAssertEqual("0xf889808609184e72a00082271094000000000000000000000000000000000000000080a47f746573743200000000000000000000000000000000000000000000000000000060005726a0e334b3350ecadf15dfe6ac58c75b386e6b5e6ef997589e62368c7c74777abd67a00ace9b8c332799dd54da03c8a44c3191b456b2f067ad575d4022d3a81e9318c7", data.toHexString().addHexPrefix())
    }
    
    func testSign1() {
        let transaction = EthereumRawTransaction(value: Wei("1000000000000000000")!,
                                                 to: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F",
                                                 gasPrice: 99000000000,
                                                 gasLimit: 21000,
                                                 nonce: 0)
        let pk = Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        let data = try! EIP155Signer(chainId: 1).sign(transaction, privateKey: pk);
        XCTAssertEqual("0xf86c8085170cdc1e008252089491c79f31de5208fadcbf83f0a7b0a9b6d8aba90f880de0b6b3a76400008025a0f62b35ed65db13b02ccab29eeea2d29990a690a8620f8bee56b765c5357c82b8a05c266f2d429c87f8c903f7089870aa169638518c5c3a56ade8ce66ffcb5c3991", data.toHexString().addHexPrefix())
        
    }
    
    func testBitcoinSign() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .bitcoin)
        
        let pk = PrivateKey(pk: "KxCPHuQByyyf1RdcbXgWXqigzKAYeoTieGd4ezYcjQPVcGh5P9PC", coin: .bitcoin)
        let address = try! LegacyAddress(pk.publicKey.address)
        let addr = Cashaddr(data: pk.raw, type: .pubkeyHash, network: .mainnet)
        let utxoWallet = UTXOWallet(privateKey: pk)
        do {
            let signedTx = try utxoWallet.createTransaction(to: address, amount: 10, utxos: [])
            XCTAssertEqual(signedTx, "01000000000200000000000000001976a9140c538bc8df14c3017234e8495174453e732cfd8f88ac00000000000000001976a9140c538bc8df14c3017234e8495174453e732cfd8f88ac00000000")
            
        } catch {
            print(error)
        }
        
    }
}
