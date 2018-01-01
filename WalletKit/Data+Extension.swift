//
//  Data+Extension.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension Data {
    var bytes: Array<UInt8> {
        return Array(self)
    }
}
