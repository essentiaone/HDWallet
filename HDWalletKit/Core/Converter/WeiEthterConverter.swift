//
//  WeiEthterConverter.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 10/10/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public class  WeiEthterConverter {
    
    // NOTE: calculate wei by 10^18
    private static let etherInWei = pow(Decimal(10), 18)
    
    /// Convert Wei(BInt) unit to Ether(Decimal) unit
    public static func toEther(wei: Wei) throws -> Ether {
        guard let decimalWei = Decimal(string: wei.description) else {
            throw HDWalletKitError.convertError(.failedToConvert(wei.description))
        }
        return decimalWei / etherInWei
    }
    
    /// Convert Ether(Decimal) unit to Wei(BInt) unit
    public static func toWei(ether: Ether) throws -> Wei {
        guard let wei = Wei((ether * etherInWei).description) else {
            throw HDWalletKitError.convertError(.failedToConvert(ether * etherInWei))
        }
        return wei
    }
    
    /// Convert Ether(String) unit to Wei(BInt) unit
    public static func toWei(ether: String) throws -> Wei {
        guard let decimalEther = Decimal(string: ether) else {
            throw HDWalletKitError.convertError(.failedToConvert(ether))
        }
        return try toWei(ether: decimalEther)
    }
    
    ///Convert Wei to Tokens balance
    public static func toToken(balance: String, decimals: Int, radix: Int) throws -> Ether {
        guard let wei = Wei(balance, radix: radix),
              let  decimalWei = Decimal(string: wei.description) else {
            throw HDWalletKitError.convertError(.failedToConvert(balance))
        }
        return decimalWei / pow(10, decimals)
    }
    
    // Only used for calcurating gas price and gas limit.
    public static func toWei(GWei: Int) -> Int {
        return GWei * 1000000000
    }
}
