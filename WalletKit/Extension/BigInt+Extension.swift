//
//  BigInt+Extension.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension BInt {
    public init?(hex: String) {
        self.init(number: hex.lowercased(), withBase: 16)
    }
}
