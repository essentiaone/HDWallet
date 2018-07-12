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
      let network = Network.main(.bitcoin)
      let privateKey = PrivateKey(seed: seed, network: network)
      
      XCTAssertEqual(
         privateKey.extended,
         "xprv9s21ZrQH143K2XojduRLQnU8D8K59KSBoMuQKGx8dW3NBitFDMkYGiJPwZdanjZonM7eXvcEbxwuGf3RdkCyyXjsbHSkwtLnJcsZ9US42Gd"
      )
      
      // BIP44 key derivation
      // m/44'
      let purpose = privateKey.derived(at: .hardened(44))
      
      // m/44'/0'
      let coinType = purpose.derived(at: .hardened(0))
      
      // m/44'/0'/0'
      let account = coinType.derived(at: .hardened(0))
      
      // m/44'/0'/0'/0
      let change = account.derived(at: .notHardened(0))
      
      XCTAssertEqual(
         change.extended,
         "xprvA2QWrMvVn11Cnc8Wv5XH22Phaz1eLLYUtUVCJxjRu3eSbPZk3WphdkqGBnAKiKtg3bxkL48zbf9C8jJKtbDhB4kTJuNfv3KZVRjxseHNNWk"
      )
      
      XCTAssertEqual(
         change.publicKey.extended,
         "xpub6FPsFsTPcNZW16Cz274HPALS91r8joGLFhQo7M93TPBRUBttb48xBZ9k34oiG29Bvqfry9QyXPsGXSRE1kjut92Dgik1w6Whm1GU4F122n8"
      )
      
      // m/44'/0'/0'/0/0
      let firstPrivateKey = change.derived(at: .notHardened(0))
      XCTAssertEqual(
         firstPrivateKey.publicKey.address,
         "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5"
      )
      
      XCTAssertEqual(
         firstPrivateKey.publicKey.raw.toHexString(),
         "03ce9b978595558053580d557ff40f9f99a4f1a7609c25268863ee64de7e4abbda"
      )
   }
   
   func testTestnetChildKeyDerivation() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let network = Network.test(.bitcoin)
      let privateKey = PrivateKey(seed: seed, network: network)
      
      XCTAssertEqual(
         privateKey.extended,
         "tprv8ZgxMBicQKsPdM3GJUGqaS67XFjHNqUC8upXBhNb7UXqyKdLCj6HnTfqrjoEo6x89neRY2DzmKXhjWbAkxYvnb1U7vf4cF4qDicyb7Y2mNa"
      )
      
      // BIP44 key derivation
      // m/44'
      let purpose = privateKey.derived(at:.hardened(44))
      
      // m/44'/0'
      let coinType = purpose.derived(at: .hardened(network.coinType) )
      
      // m/44'/0'/0'
      let account = coinType.derived(at: .hardened(0))
      
      // m/44'/0'/0'/0
      let change = account.derived(at: .notHardened(0))
      
      XCTAssertEqual(
         change.extended,
         "tprv8hJrzKEmbFfBx44tsRe1wHh25i5QGztsawJGmxeqryPwdXdKrgxMgJUWn35dY2nrYmomRWWL7Y9wJrA6EvKJ27BfQTX1tWzZVxAXrR2pLLn"
      )
      
      XCTAssertEqual(
         change.publicKey.extended,
         "tpubDDzu8jH1jdLrqX6gm5JcLhM8ejbLSL5nAEu44Uh9HFCLU1t6V5mwro6NxAXCfR2jUJ9vkYkUazKXQSU7WAaA9cbEkxdWmbLxHQnWqLyQ6uR"
      )
      
      // m/44'/0'/0'/0
      let firstPrivateKey = change.derived(at: .notHardened(0))
      XCTAssertEqual(
         firstPrivateKey.publicKey.address,
         "mq1VMMXiZKLdY2WLeaqocJxXijhEFoQu3X"
      )
      
      XCTAssertEqual(
         firstPrivateKey.publicKey.raw.toHexString(),
         "037e63dc23f0f6ecb0b2ab8a649f0e2966e9c6ceb10f901e0e0b712cfed2f78449"
      )
   }
   
   func testBitcoinMainNetAddressGeneration() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let wallet = Wallet(seed: seed, network: .main(.bitcoin))
      
      let firstAddress = wallet.generateAddress(at: 0)
      XCTAssertEqual(firstAddress, "128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5")
      
      let secondAddress = wallet.generateAddress(at: 1)
      XCTAssertEqual(secondAddress, "1E7NvpF3u87rbpfYxt3HDmpFasPiU2JhMp")
      
      let thirdAddress = wallet.generateAddress(at: 2)
      XCTAssertEqual(thirdAddress, "12KtZ5SXaQGT2iL89VoFQMuuutPUwXmqdL")
      
      let forthAddress = wallet.generateAddress(at: 3)
      XCTAssertEqual(forthAddress, "1NPN2MZ2iKK4a1Bav8D4MHYVG6mTetV8xb")
      
   }
   
   func testBitcoinTestNetAddressGeneration() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let wallet = Wallet(seed: seed, network: .test(.bitcoin))
      
      let firstAddress = wallet.generateAddress(at: 0)
      XCTAssertEqual(firstAddress, "mq1VMMXiZKLdY2WLeaqocJxXijhEFoQu3X")
      
      let secondAddress = wallet.generateAddress(at: 1)
      XCTAssertEqual(secondAddress, "mu7gEKi6LWdWTMdEpux3v79huagEZFMJBN")
      
      let thirdAddress = wallet.generateAddress(at: 2)
      XCTAssertEqual(thirdAddress, "mhDiBvv9fo4pUrDiC4wLS1gS8x9EBuvagg")
      
      let forthAddress = wallet.generateAddress(at: 3)
      XCTAssertEqual(forthAddress, "mqwDZupDkKsaLsEEDAC9yKtQW6AFTsNeCh")
      
   }
   
   func testLitecoinAddressGeneration() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let wallet = Wallet(seed: seed, network: .main(.litecoin))
      
      let firstAddress = wallet.generateAddress(at: 0)
      XCTAssertEqual(firstAddress, "LV8fThzQw45HT6bCgs1yfvLNzv4aFvjJt1")
      
      let secondAddress = wallet.generateAddress(at: 1)
      XCTAssertEqual(secondAddress, "Lg7bkp36nPJdqoYAfpmR1UUdXgSq9iCxBX")
      
      let thirdAddress = wallet.generateAddress(at: 2)
      XCTAssertEqual(thirdAddress, "LRajgVNRke9ttvrnncpH52iNAbCFdSxq2b")
      
      let forthAddress = wallet.generateAddress(at: 3)
      XCTAssertEqual(forthAddress, "LcZoNSHLQc1XGjMLy6PdqE8PtphMbRPCQ3")
   }
   
   func testBitcoinCashAddressGeneration() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let wallet = Wallet(seed: seed, network: .main(.bitcoinCash))
      
      let firstAddress = wallet.generateAddress(at: 0)
      XCTAssertEqual(firstAddress, "1FYh9oXWbAzgcX3hPSrRWUodYWt87bMmne")
      
      let secondAddress = wallet.generateAddress(at: 1)
      XCTAssertEqual(secondAddress, "19Q2M5swtorWmL9ZdhtaxBFFuhUuBr9z1Q")
      
      let thirdAddress = wallet.generateAddress(at: 2)
      XCTAssertEqual(thirdAddress, "1QDAX8eZXMjVdZxMzHyXr81uWu9ZDWd9vR")
      
      let forthAddress = wallet.generateAddress(at: 3)
      XCTAssertEqual(forthAddress, "1Jgjm6m4ETPGezaoTBdJCJV7RCjDRR9Ddf")
   }
   
   func testBitcoinMainNetAccountGeneration() {
      let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
      let mnemonic = Mnemonic.create(entropy: entropy)
      let seed = Mnemonic.createSeed(mnemonic: mnemonic)
      let network: Network = .main(.bitcoin)
      let wallet = Wallet(seed: seed, network: network)
      let privateKey0 = bip44PrivateKey(network: network, from:wallet.privateKey).derived(at: .notHardened(0))
      let privateKey1 = bip44PrivateKey(network: network, from:wallet.privateKey).derived(at: .notHardened(1))
      let accounts:[String] = [Account(privateKey: privateKey0),
                               Account(privateKey: privateKey1)].compactMap { (account) -> String in
                                 return account.address
      }
      let generatedAccounts:[String] = wallet.generateAccounts(count: 2).compactMap { (account) -> String in
         return account.address
      }
      XCTAssertEqual(generatedAccounts, accounts)
      
   }
   
   func bip44PrivateKey(network: Network , from: PrivateKey) -> PrivateKey {
      let bip44Purpose:UInt32 = 44
      let purpose = from.derived(at: .hardened(bip44Purpose))
      let coinType = purpose.derived(at: .hardened(network.coinType))
      let account = coinType.derived(at: .hardened(0))
      let receive = account.derived(at: .notHardened(0))
      return receive
   }
}
