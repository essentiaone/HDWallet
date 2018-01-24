//
//  KeyGeneratorType.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public protocol KeyGeneratorType {
    init(seedString: String, network: Network)
}
