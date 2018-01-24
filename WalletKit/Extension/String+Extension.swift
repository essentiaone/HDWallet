//
//  String+Extension.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension String {
    var mnemonicData: Data {
        var mnemonicData = Data(capacity: count / 2)
        var index = 0
        var charactors = ""
        
        forEach { charactor in
            charactors += String(charactor)
            if index % 2 == 1 {
                let i = UInt8(strtoul(charactors, nil, 16))
                mnemonicData.append(i)
                charactors = ""
            }
            index += 1
        }
        
        return mnemonicData
    }
    
    var bytes: [UInt8] {
        return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? []
    }
}

// MARK: Base58Encoding
extension String {
    var base58EncodingString: String {
        guard var big = BInt(self) else {
            fatalError("Could not initialize BigInt with value of \(self)")
        }
        
        let base58EncodeCharacters: [Character] = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "A", "B", "C", "D", "E", "F", "G", "H", "J",
            "K", "L", "M", "N", "P", "Q", "R", "S", "T",
            "U", "V", "W", "X", "Y", "Z",
            "a", "b", "c", "d", "e", "f", "g", "h", "i",
            "j", "k", "m", "n", "o", "p", "q", "r", "s",
            "t", "u", "v", "w", "x", "y", "z"
        ]
        
        var base58encodedString = ""
        while big > 0 {
            let bigRemainder  = big % 58
            let remainder = Int(bigRemainder.description)
            base58encodedString = String("\(base58EncodeCharacters[remainder!])\(base58encodedString)")
            big = big / 58
        }
        
        return base58encodedString
    }
}
