//
//  UInt32.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension UInt32 {
    var toHexData: Data {
        var v = byteSwapped
        return Data(bytes: &v, count: MemoryLayout<UInt32>.size)
    }
}
