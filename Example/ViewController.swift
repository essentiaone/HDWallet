//
//  ViewController.swift
//  Example
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import UIKit
import WalletKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        // abandon amount liar amount expire adjust cage candy arch gather drum buyer
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        print(seed.toHexString())
        
        // By calling initialize, you can now access to your wallet.
        let wallet = Wallet(seed: seed, network: .main)
        print(wallet.generateAddress(at: 0))
    }
}
