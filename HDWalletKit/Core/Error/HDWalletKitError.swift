//
//  HDWalletKitError.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public enum HDWalletKitError: Error {
    public enum CryptoError {
        case failedToEncode(element:Any)
    }
    
    public enum ContractError: Error {
        case containsInvalidCharactor(Any)
        case invalidDecimalValue(Any)
    }
    
    public enum ConvertError: Error {
        case failedToConvert(Any)
    }
    
    case cryptoError(CryptoError)
    case contractError(ContractError)
    case convertError(ConvertError)
    case failedToSign
    case noEnoughSpace
    case unknownError
}
