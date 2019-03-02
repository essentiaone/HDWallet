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
    case utxo(addresses: [AddressProtocol])
    
    public var path: String {
        switch self {
        case .utxo(let addresses):
            let parameter: String = "[" + addresses.map { "\"\($0.cashaddr)\"" }.joined(separator: ",") + "]"
            return "address/utxo/\(parameter)"
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
