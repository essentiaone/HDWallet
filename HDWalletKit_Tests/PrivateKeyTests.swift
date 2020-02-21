//
//  PrivateKeyTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 4/18/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class PrivateKeyTests: XCTestCase {
    
    func testBitcoin() {
        let address = "1MVEQHYUv1bWiYJB77NNEEEdbmNFEoW5q6"
        let rawPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
        
        let hexPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
        let uncompressedPk = "5HvdNYs1baLY7vpnmb2osg5gZHvAFxDiBoCujs2vfTjC442rzSK"
        let compressedPk = "KwhhY7djdc9EMaZw1oCytfVfbXfdrzj6newZnBqVrkyDnKVWiCmJ"
        [hexPk, compressedPk, uncompressedPk].forEach {
            testImportFromPK(coin: .bitcoin, privateKey: $0, address: address, raw: rawPk)
        }
    }
    
    func testBitcoinCash() {
        let address = "1MVEQHYUv1bWiYJB77NNEEEdbmNFEoW5q6"
        let rawPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
        
        let hexPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
        let uncompressedPk = "5HvdNYs1baLY7vpnmb2osg5gZHvAFxDiBoCujs2vfTjC442rzSK"
        let compressedPk = "KwhhY7djdc9EMaZw1oCytfVfbXfdrzj6newZnBqVrkyDnKVWiCmJ"
        [hexPk, uncompressedPk, compressedPk].forEach {
            testImportFromPK(coin: .bitcoinCash, privateKey: $0, address: address, raw: rawPk)
        }
    }
    
    func testDogecoin() {
         let address = "DHhBBVF46Wzc8pR6swZD9GoDdX8x7MDgvw"
         let rawPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
         
         let hexPk = "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"
         let uncompressedPk = "6KetuZozmLRbBFKM474EcBNFo5w6zuRRWM661hjFZzobJoLuNCh"
         let compressedPk = "KwhhY7djdc9EMaZw1oCytfVfbXfdrzj6newZnBqVrkyDnKVWiCmJ"
         [hexPk, uncompressedPk, compressedPk].forEach {
             testImportFromPK(coin: .bitcoinCash, privateKey: $0, address: address, raw: rawPk)
         }
    }
    
    func testLitecoin() {
        let address = "Lbre6AY3tc8X2GJ2tKERVvcCA4S2EzF6wJ"
        let rawPk = "857cfceb9726ba7165fdcda93c056d35a8ba9b90a8c77fac524a309d832de107"
        
        let hexPk = "857cfceb9726ba7165fdcda93c056d35a8ba9b90a8c77fac524a309d832de107"
        let uncompressedPk = "6v8opvTbpSE2WwTv4rhEvSVK1jqGTXKRkWk484gxmc4TtQzDu53"
        let compressedPk = "T7XTgWxQgNLVh9PoE2LcSsVxWG43E4pLF4H2nBHP9skHfjshodfM"
        [hexPk, uncompressedPk, compressedPk].forEach {
            testImportFromPK(coin: .litecoin, privateKey: $0, address: address, raw: rawPk)
        }
    }
    
    func testImportFromPK(coin: Coin, privateKey: String, address: String, raw: String) {
        let pk = PrivateKey(pk: privateKey, coin: coin)
        XCTAssertEqual(pk!.publicKey.address, address)
        XCTAssertEqual(pk?.raw, Data(hex: raw))
    }
    
}

