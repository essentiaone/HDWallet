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
    
    func testBitcoinWifUncompressed() {
        let pk = PrivateKey(pk: "5HvdNYs1baLY7vpnmb2osg5gZHvAFxDiBoCujs2vfTjC442rzSK", coin: .bitcoin)
        XCTAssertEqual(pk!.publicKey.address, "1MVEQHYUv1bWiYJB77NNEEEdbmNFEoW5q6")
        XCTAssertEqual(pk?.raw, Data(hex: "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"))
    }
    
    func testBitcoinHex() {
        let pk = PrivateKey(pk: "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c", coin: .bitcoin)
        XCTAssertEqual(pk!.publicKey.address, "1MVEQHYUv1bWiYJB77NNEEEdbmNFEoW5q6")
        XCTAssertEqual(pk?.raw, Data(hex: "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"))
    }
    
    func testBitcoinWifCompressed() {
        let pk = PrivateKey(pk: "KwhhY7djdc9EMaZw1oCytfVfbXfdrzj6newZnBqVrkyDnKVWiCmJ", coin: .bitcoin)
        XCTAssertEqual(pk!.publicKey.address, "1MVEQHYUv1bWiYJB77NNEEEdbmNFEoW5q6")
        XCTAssertEqual(pk?.raw, Data(hex: "0e66055a963cc3aecb185cf795de476cf290c88db671297da041b7f7377e6f9c"))
    }
    
}

