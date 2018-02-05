//
//  Crypto.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import CryptoSwift

final class Crypto {
    static func HMACSHA512(key: String, data: Data) -> [UInt8] {
        let output: [UInt8]
        do {
            output = try HMAC(key: "Bitcoin seed", variant: .sha512).authenticate(data.bytes)
        } catch let error {
            fatalError("Error occured. Description: \(error.localizedDescription)")
        }
        return output
    }
}
