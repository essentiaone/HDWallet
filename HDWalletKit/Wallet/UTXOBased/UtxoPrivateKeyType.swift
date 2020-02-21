//
//  UtxoPrivateKeyType.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 4/17/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public enum UtxoPrivateKeyType {
    case wifUncompressed
    case wifCompressed
    case hex
    
    private func regexForCoin(coin: Coin) -> String {
        switch coin {
        case .bitcoin:
            switch self {
            case .hex:
                return "^\\p{XDigit}+$"
            case .wifCompressed:
                return "[KL][1-9A-HJ-NP-Za-km-z]{51}"
            case .wifUncompressed:
                return "^5[HJK][0-9A-Za-z&&[^0OIl]]{49}"
            }
        case .litecoin:
            switch self {
            case .hex:
                return "^\\p{XDigit}+$"
            case .wifCompressed:
                return "[T][1-9A-HJ-NP-Za-km-z]{51}"
            case .wifUncompressed:
                return "^6[uv][1-9A-HJ-NP-Za-km-z]{49}"
            }
        case .ethereum:
            return "^\\p{XDigit}+$"
        case .bitcoinCash:
            switch self {
            case .hex:
                return "^\\p{XDigit}+$"
            case .wifCompressed:
                return "[KL][1-9A-HJ-NP-Za-km-z]{51}"
            case .wifUncompressed:
                return "^5[HJK][0-9A-Za-z&&[^0OIl]]{49}"
            }
        case .dash:
            switch self {
            case .hex:
                return "^\\p{XDigit}+$"
            case .wifCompressed:
                return "[X][1-9A-HJ-NP-Za-km-z]{51}"
            case .wifUncompressed:
                return "^7[rs][1-9A-HJ-NP-Za-km-z]{49}"
            }
        case .dogecoin:
            switch self {
            case .hex:
                return "^\\p{XDigit}+$"
            case .wifCompressed:
                return "[Q][1-9A-HJ-NP-Za-km-z]{51}"
            case .wifUncompressed:
                return "^6[LKJ][1-9A-HJ-NP-Za-km-z]{49}"
            }
        }
    }
    
    static func pkType(for pk: String, coin: Coin) -> UtxoPrivateKeyType? {
        let range = NSRange(location: 0, length: pk.utf16.count)
        return [UtxoPrivateKeyType.wifUncompressed, .wifCompressed, .hex].first(where: {
            let regexString = $0.regexForCoin(coin: coin)
            let regex = try? NSRegularExpression(pattern: regexString, options: [])
            return regex?.matches(in: pk, options: [], range: range).count == 1
        })
    }
}
