//
//  CryptoTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class CryptoTests: XCTestCase {
    func testSHA3Keccak256() {
        let data = "Hello".data(using: .utf8)!
        let encrypted = Crypto.sha3keccak256(data: data)
        XCTAssertEqual(encrypted.toHexString(), "06b3dfaec148fb1bb2b066f10ec285e7c9bf402ab32aa78a5d38e34566810cd2")
    }
    
    func testPrivateKeySign() {
        let signer = EIP155Signer(chainId: 1)
        
        let rawTransaction1 = EthereumRawTransaction(
            value: Wei("10000000000000000")!,
            to: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F",
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 2
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction1).toHexString(),
            "de6ed032e8f09adb557f6a0ebc16ed52d6a75e0644a77a236aa1cfffa7746e9a"
        )
        
        let rawTransaction2 = EthereumRawTransaction(
            value: Wei("10000000000000000")!,
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gasPrice: 99000000000,
            gasLimit: 200000,
            nonce: 4
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction2).toHexString(),
            "b148272b2a985365e08abb17a85ca5e171169978f3b55e6852a035f83b9f3aa5"
        )
        
        let rawTransaction3 = EthereumRawTransaction(
            value: Wei("20000000000000000")!,
            to: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1",
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 25
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction3).toHexString(),
            "280e29f030cfa256b4298a2b834a4add92b37f159b3cce1110e1ff9f7514f9fe"
        )
    }
    
    func testGeneratingRSV() {
        let signature = Data(hex: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")
        let signer = EIP155Signer(chainId: 1)
        let (r, s, v) = signer.calculateRSV(signature: signature)
        XCTAssertEqual(r, BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!)
        XCTAssertEqual(s, BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!)
        XCTAssertEqual(v, BInt(37))
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(signature, restoredSignature)
    }
    
    func testRestoringSignatureSignedWithOldScheme() {
        let v = 27
        let r = "75119860711638973245538703589762310947594328712729260330312782656531560398776"
        let s = "51392727032514077370236468627319183981033698696331563950328005524752791633785"
        let signer = EIP155Signer(chainId: 1)
        let signature = signer.calculateSignature(r: BInt(r)!, s: BInt(s)!, v: BInt(v))
        XCTAssertEqual(signature.toHexString(), "a614559de76862bb1dbf8a969d8979e5bf21b72c51c96b27b3d247b728ebffb8719f40b018940ffd0880285d2196cdd31a710bf7cdda60c77632743d687dff7900")
        
        let r1 = "79425995431864040500581522255237765710685762616259654871112297909982135982384"
        let s1 = "1777326029228985739367131500591267170048497362640342741198949880105318675913"
        let signature1 = signer.calculateSignature(r: BInt(r1)!, s: BInt(s1)!, v: BInt(v))
        XCTAssertEqual(signature1.toHexString(), "af998533cdac5d64594f462871a8ba79fe41d59295e39db3f069434c9862193003edee4e64d899a2c57bd726e972bb6fdb354e3abcd5846e2315ecfec332f5c900")
    }
    
    func testCreatePublicKey() {
        let pk = PrivateKey(pk: "L5GgBH1U8PuNuzCQGvvEH3udEXCEuJaiK96e88romhpGa1cU7JTY", coin: .bitcoin)!
        let publicKey = Crypto.generatePublicKey(data: pk.raw, compressed: true)
        XCTAssertEqual(publicKey.toHexString(), "0346a4129884b46fdb7f7977c6e90ed4c367af343494f3ff5272db721752d28ef3")
    }
    
    func bip44PrivateKey(coin: Coin , from: PrivateKey) -> PrivateKey {
        let bip44Purpose:UInt32 = 44
        let purpose = from.derived(at: .hardened(bip44Purpose))
        let coinType = purpose.derived(at: .hardened(coin.coinType))
        let account = coinType.derived(at: .hardened(0))
        let receive = account.derived(at: .notHardened(0))
        return receive
    }

     func testPublickKeyHashOutFromPubKeyHash() {
        let expected = "76a9210392030131e97b2a396691a7c1d91f6b5541649b75bda14d056797ab3cadcaf2f588ac"
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let privateKey = PrivateKey(seed: seed, coin: .bitcoin)
        let publicKey = privateKey.publicKey.data
        let hash = Script.buildPublicKeyHashOut(pubKeyHash: publicKey)
        XCTAssertEqual(hash.toHexString(), expected)
    }
}
