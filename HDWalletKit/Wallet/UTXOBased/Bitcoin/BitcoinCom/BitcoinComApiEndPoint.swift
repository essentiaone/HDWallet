//
//  BitcoinComApiEndPoint.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

public enum BitcoinComApiEndPoint: RequestProtocol {
    case utxo(address: AddressProtocol)
    
    public var path: String {
        switch self {
        case .utxo(let address):
            return "address/utxo/\(address.cashaddr)"
        }
    }
    
    public var extraHeaders: HTTPHeader? {
        return nil
    }
    
    public var parameters: HTTParametrs? {
        return nil
    }
    
    public var requestType: RequestType {
        return .get
    }
    
    public var contentType: RequestContentType {
        return .json
    }
}
