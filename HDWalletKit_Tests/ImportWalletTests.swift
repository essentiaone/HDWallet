//
//  ImportWalletTests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 5/5/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class ImportWalletTests: XCTestCase {
    
    func testImportBitcoinAddress() {
        let legacy = try! LegacyAddress("1FYh9oXWbAzgcX3hPSrRWUodYWt87bMmne", coin: .bitcoinCash)
        XCTAssertEqual(legacy.data.toHexString(), "9f902c3c088cc352eae162bcb8fb0540b47c9711")
        XCTAssertEqual(legacy.cashaddr, "bitcoincash:qz0eqtpupzxvx5h2u93tew8mq4qtglyhzyjdq3ezw0")
        XCTAssertEqual(legacy.base58, "1FYh9oXWbAzgcX3hPSrRWUodYWt87bMmne")
    }
    
    func testImportBitcoinCashAddress() {
        let bch = try! BitcoinCashAddress("bitcoincash:qz0eqtpupzxvx5h2u93tew8mq4qtglyhzyjdq3ezw0")
        XCTAssertEqual(bch.data.toHexString(), "9f902c3c088cc352eae162bcb8fb0540b47c9711")
        XCTAssertEqual(bch.cashaddr, "bitcoincash:qz0eqtpupzxvx5h2u93tew8mq4qtglyhzyjdq3ezw0")
        XCTAssertEqual(bch.base58, "1FYh9oXWbAzgcX3hPSrRWUodYWt87bMmne")
    }
}
