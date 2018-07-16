//
//  String+Hex.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

fileprivate var hexPrefix = "0x"

extension String {
    
    public func stripHexPrefix() -> String {
        var hex = self
        if hex.hasPrefix(hexPrefix) {
            hex = String(hex.dropFirst(hexPrefix.count))
        }
        return hex
    }
    
    public func addHexPrefix() -> String {
        return hexPrefix.appending(self)
    }
    
    public func toHexString() -> String {
        guard let data = data(using: .utf8) else {
            return ""
        }
        return data.map { String(format: "%02x", $0) }.joined()
    }
}
