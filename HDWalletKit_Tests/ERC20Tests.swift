//
//  ERC20Tests.swift
//  HDWalletKit_Tests
//
//  Created by Pavlo Boiko on 24.09.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import HDWalletKit

fileprivate enum Constants {
    static var ethereumAddress = "2f5059f64D5C0c4895092D26CDDacC58751e0C3C"
    static var smartContractAddress = "0x8f0921f30555624143d427b340b1156914882c10"
}

final class ERC20Tests: XCTestCase {
    var erc20Token: ERC20!
    
    override func setUp() {
        erc20Token = ERC20(contractAddress: Constants.smartContractAddress, decimal: 18, symbol: "TEST")
    }
    
    func testGenerateTransactionData() {
        let expectations = ["3": "0xa9059cbb0000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c00000000000000000000000000000000000000000000000029a2241af62c0000",
                            "0.25": "0xa9059cbb0000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c00000000000000000000000000000000000000000000000003782dace9d90000",
                            "0.155555": "0xa9059cbb0000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c0000000000000000000000000000000000000000000000000228a472c6093000",
                            "3000": "0xa9059cbb0000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c0000000000000000000000000000000000000000000000a2a15d09519be00000",
                            "9000": "0xa9059cbb0000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c0000000000000000000000000000000000000000000001e7e4171bf4d3a00000"]
        expectations.forEach { (expectations) in
            calculateTransaction(with: expectations.key, expentation: expectations.value)
        }
    }
    
    func calculateTransaction(with ammount: String, expentation: String) {
        let data = try! erc20Token.generateSendBalanceParameter(toAddress: Constants.ethereumAddress, amount: ammount)
        XCTAssertEqual(data.toHexString().addHexPrefix(), expentation)
    }

    func testGenerateGetBalanceParameter() {
        let data = try! erc20Token.generateGetBalanceParameter(toAddress: Constants.ethereumAddress)
        XCTAssertEqual(
            data.toHexString().addHexPrefix(),
            "0x70a082310000000000000000000000002f5059f64d5c0c4895092d26cddacc58751e0c3c"
        )
    }
    
    
    func testSignatures() {
        XCTAssertEqual(erc20Token.transferSignature.toHexString(), "a9059cbb")
        XCTAssertEqual(erc20Token.balanceSignature.toHexString(), "70a08231")
    }
}

