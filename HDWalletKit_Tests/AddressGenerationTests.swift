//
//  AddressGenerationTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class AddressGenerationTests: XCTestCase {
    func testMainnetChildKeyDerivation() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let privateKey = PrivateKey(seed: seed, coin: .bitcoin)
        
        // BIP44 key derivation
        // m/44'
        let purpose = privateKey.derived(at: .hardened(44))
        
        // m/44'/0'
        let coinType = purpose.derived(at: .hardened(0))
        
        // m/44'/0'/0'
        let account = coinType.derived(at: .hardened(0))
        
        // m/44'/0'/0'/0
        let change = account.derived(at: .notHardened(0))
        
        // m/44'/0'/0'/0/0
        let firstPrivateKey = change.derived(at: .notHardened(0))
        XCTAssertEqual(
            firstPrivateKey.publicKey.address,
            "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5"
        )
        
        XCTAssertEqual(
            firstPrivateKey.publicKey.compressedPublicKey.toHexString(),
            "03ce9b978595558053580d557ff40f9f99a4f1a7609c25268863ee64de7e4abbda"
        )
    }
    

    
    func testBitcoinMainNetAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .bitcoin)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5")
        XCTAssertEqual(firstAccount.rawPublicKey, "03ce9b978595558053580d557ff40f9f99a4f1a7609c25268863ee64de7e4abbda")
        XCTAssertEqual(firstAccount.rawPrivateKey, "L35qaFLpbCc9yCzeTuWJg4qWnTs9BaLr5CDYcnJ5UnGmgLo8JBgk")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "1E7NvpF3u87rbpfYxt3HDmpFasPiU2JhMp")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "12KtZ5SXaQGT2iL89VoFQMuuutPUwXmqdL")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "1NPN2MZ2iKK4a1Bav8D4MHYVG6mTetV8xb")
        
    }
    
    
    func testEthereumAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
        XCTAssertEqual(firstAccount.rawPublicKey, "039966a68158fcf8839e7bdbc6b889d4608bd0b4afb358b073bed1d7b70dbe2f4f")
        XCTAssertEqual(firstAccount.rawPrivateKey, "df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf")
    }
    
    func testLitecoinAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .litecoin)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "LV8fThzQw45HT6bCgs1yfvLNzv4aFvjJt1")
        XCTAssertEqual(firstAccount.rawPublicKey, "026eeb12b93ab20b32970e2fa0e7fbaa97f9016dc743ad3efc922681ce33adc40d")
        XCTAssertEqual(firstAccount.rawPrivateKey, "T3d12aqL7XSNqMojMtqBZGhQ6E93dzrdbnNUKMvdmVTa9TQn4L3m")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "Lg7bkp36nPJdqoYAfpmR1UUdXgSq9iCxBX")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "LRajgVNRke9ttvrnncpH52iNAbCFdSxq2b")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "LcZoNSHLQc1XGjMLy6PdqE8PtphMbRPCQ3")
    }
    
    func testDashAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .dash)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "Xud1fZjupDuhndpYtTquDPmSWmehtEbxhy")
        XCTAssertEqual(firstAccount.rawPublicKey, "02f1dfce053d0a9aadb8f63ab4490ac84b33ad018c62dbabb9ff2352fe62fc4619")
        XCTAssertEqual(firstAccount.rawPrivateKey, "XCHbiHeTfzwhryHEZTp3ojAM1nYpKwL575ieLLv7s4q1f5ZEm1vP")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "XbATV62bhk2P1Vkroc1QXX3vqJuSxvvDta")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "XoWa4HnW9u8fWQHaAPH9YirPcUZVVEdMMk")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "XnckifVkTXKkSQf3k7LKPVYaVfycuXQhZ6")
    }
    
    func testDogecoinAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .dogecoin)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "DSsPuTmCThdr1qkgJ49K1mHskypbi2LTrS")
        XCTAssertEqual(firstAccount.rawPublicKey, "0372caf38ff987350d04a24cad8436b3c9337d9bc0ebab2a39682d621c34ddc99b")
        XCTAssertEqual(firstAccount.rawPrivateKey, "6KJYQ2MeVTWDA7gA9YCGn2GpHwe4679QY874nLmp6U1jjHgDnHg")
        
        let secondAddress = wallet.generateAddress(at: 1)
        XCTAssertEqual(secondAddress, "DCvD62aLgZSuAvSxbFPyyLaaSHjFNAmDye")
        
        let thirdAddress = wallet.generateAddress(at: 2)
        XCTAssertEqual(thirdAddress, "DRa2dkLbiezQ23ubYbjUwgJRZff1GHpT7p")
        
        let forthAddress = wallet.generateAddress(at: 3)
        XCTAssertEqual(forthAddress, "D99a5gvcaWxy5fugLymc629j8bBX33KPo9")
    }
    
    
    func testBitcoinCashAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .bitcoinCash)
        
        let firstAccount = wallet.generateAccount(at: 0)
        XCTAssertEqual(firstAccount.address, "1FYh9oXWbAzgcX3hPSrRWUodYWt87bMmne")
        XCTAssertEqual(firstAccount.privateKey.publicKey.generateCashAddress(),
                       "bitcoincash:qz0eqtpupzxvx5h2u93tew8mq4qtglyhzyjdq3ezw0")
        XCTAssertEqual(firstAccount.rawPublicKey, "030f6c58f37ffe1bf56dd79fac07f339f44d96efaa3d78e1f32fadd41dcd0b7bbc")
        XCTAssertEqual(firstAccount.rawPrivateKey, "KwgDcj2ZDN5vzRXsTv1F6vzQV7nx7shEYjFBcWng1sH6Fy9rhK2b")
        
        let secondAccount = wallet.generateAccount(at: 1)
        XCTAssertEqual(secondAccount.address, "19Q2M5swtorWmL9ZdhtaxBFFuhUuBr9z1Q")
        XCTAssertEqual(secondAccount.privateKey.publicKey.generateCashAddress(),
                       "bitcoincash:qpwphvnuxqxxg9z9m4f7vkuyrzu5twjasqyfxl5x3g")
        
        let thirdAccount = wallet.generateAccount(at: 2)
        XCTAssertEqual(thirdAccount.address, "1QDAX8eZXMjVdZxMzHyXr81uWu9ZDWd9vR")
        XCTAssertEqual(thirdAccount.privateKey.publicKey.generateCashAddress(),
                       "bitcoincash:qrlf04xqfxaum4w7dsk7s8q5utulazggfunjpz7tes")
        
        let forthAccount = wallet.generateAccount(at: 3)
        XCTAssertEqual(forthAccount.address, "1Jgjm6m4ETPGezaoTBdJCJV7RCjDRR9Ddf")
        XCTAssertEqual(forthAccount.privateKey.publicKey.generateCashAddress(),
                       "bitcoincash:qrqlur3v8zl500w8k5lkas4re7d70zmxtqnqp5htct")
    }
    
    func testBitcoinMainNetAccountGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .bitcoin)
        let privateKey0 = bip44PrivateKey(coin: wallet.coin, from:wallet.privateKey).derived(at: .notHardened(0))
        let privateKey1 = bip44PrivateKey(coin: wallet.coin, from:wallet.privateKey).derived(at: .notHardened(1))
        let accounts:[String] = [Account(privateKey: privateKey0),
                                 Account(privateKey: privateKey1)].compactMap { (account) -> String in
                                    return account.address
        }
        let generatedAccounts:[String] = wallet.generateAccounts(count: 2).compactMap { (account) -> String in
            return account.address
        }
        XCTAssertEqual(generatedAccounts, accounts)
        
    }
    
    func testBitcoinAddressFromPrivateKeyGeneration() {
        let privateKey = PrivateKey(pk: "L35qaFLpbCc9yCzeTuWJg4qWnTs9BaLr5CDYcnJ5UnGmgLo8JBgk", coin: .bitcoin)
        XCTAssertEqual(privateKey?.publicKey.address, "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5")
    }
    
    func testBitcoinCashFromPrivateKeyGeneration() {
        let privateKey = PrivateKey(pk: "L1a13jus2Tm8rbcJX3TMenNPCtMBD19jB4krpsfCk5mmDoZZSAft", coin: .bitcoinCash)
        XCTAssertEqual(privateKey?.publicKey.address, "19Q2M5swtorWmL9ZdhtaxBFFuhUuBr9z1Q")
        XCTAssertEqual(privateKey?.publicKey.generateCashAddress(), "bitcoincash:qpwphvnuxqxxg9z9m4f7vkuyrzu5twjasqyfxl5x3g")
    }
    
    func testEthereumAddressFromPrivateKeyGeneration() {
        let privateKey = PrivateKey(pk: "df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf", coin: .ethereum)
        XCTAssertEqual(privateKey?.publicKey.address, "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
    }
    
    func testLitecoinAddressFromPrivateKeyGeneration() {
        let privateKey = PrivateKey(pk: "T3d12aqL7XSNqMojMtqBZGhQ6E93dzrdbnNUKMvdmVTa9TQn4L3m", coin: .litecoin)
        XCTAssertEqual(privateKey?.publicKey.address, "LV8fThzQw45HT6bCgs1yfvLNzv4aFvjJt1")
    }
    
    func testDashAddressFromPrivateKeyGeneration() {
        let privateKey = PrivateKey(pk: "XJV6uhBJu5tu34hjKK2x28t9kpMUmPH4vC9xU4RDA62Yz8oKsKac", coin: .dash)
        XCTAssertEqual(privateKey?.publicKey.address, "Xqe9L4R81MhQE4MX3w38zhAJyQSSiZLZXy")
        XCTAssertEqual(privateKey?.publicKey.address, "Xqe9L4R81MhQE4MX3w38zhAJyQSSiZLZXy")
    }
    
    func bip44PrivateKey(coin: Coin , from: PrivateKey) -> PrivateKey {
        let bip44Purpose:UInt32 = 44
        let purpose = from.derived(at: .hardened(bip44Purpose))
        let coinType = purpose.derived(at: .hardened(coin.coinType))
        let account = coinType.derived(at: .hardened(0))
        let receive = account.derived(at: .notHardened(0))
        return receive
    }
}
