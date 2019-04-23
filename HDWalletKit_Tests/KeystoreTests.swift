//
//  KeystoreTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 22.08.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class KeystoreTests: XCTestCase {
    
    func testKeyStoreGeneration() {
        let data = Data("abandon amount liar amount expire adjust cage candy arch gather drum buyer".utf8)
        let passwordData =  Data("qwertyui".utf8)
        let keystore = try! KeystoreV3(data: data, passwordData: passwordData)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.cipher, "aes-128-ctr")
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdf, "scrypt")
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.r, 8)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.p, 1)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.n, 1024)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.dklen, 32)
    }
    
    func testDecodeKeystore() {
        let data = Data("abandon amount liar amount expire adjust cage candy arch gather drum buyer".utf8)
        let passwordData =  Data("qwertyui".utf8)
        let keystore = try! KeystoreV3(data: data, passwordData: passwordData)
        guard let decoded = try? keystore?.getDecriptedKeyStore(passwordData: passwordData) else {
            fatalError()
        }
        XCTAssertEqual(decoded, data)
    }
    
    
}
