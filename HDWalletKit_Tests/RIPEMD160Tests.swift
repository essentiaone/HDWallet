//
//  RIPEMD160Tests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 4/23/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

class RIPEMD160Tests: XCTestCase {
    
    func testEncode() {
        let data = Data("Essentia".utf8)
        let encodedData = Data(hex: "f70feccc344d80f6fc07ad29292c8ab3cf6753d7")
        let ripemd = RIPEMD160.hash(data)
        XCTAssertEqual(ripemd, encodedData)
    }
}
