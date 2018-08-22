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
        let data = "4e7936ba4a6bf40d0926ac9b0da0208d".data(using: .utf8)!
        let keystore = try! KeystoreV3(seed: data, password: "bYSqu6{X")
        XCTAssertEqual(keystore?.keystoreParams?.crypto.cipher, "aes-128-ctr")
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdf, "scrypt")
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.r, 8)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.p, 1)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.n, 1024)
        XCTAssertEqual(keystore?.keystoreParams?.crypto.kdfparams.dklen, 32)
    }
    
    func testDecodeKeystore() {
        let data = "4e7936ba4a6bf40d0926ac9b0da0208d".data(using: .utf8)!
        let password = "bYSqu6{X"
        let keystore = try! KeystoreV3(seed: data, password: password)
        guard let decoded = try? keystore?.getDecriptedKeyStore(password: password) else {
            assertionFailure()
            fatalError()
        }
        XCTAssertEqual(decoded, data)
    }
    
    
}
