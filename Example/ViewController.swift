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
        let wallet = Wallet(network: .testnet)
    }
}

