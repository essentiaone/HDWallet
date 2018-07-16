//
//  SecpResult.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

enum SecpResult {
    case success
    case failure
    
    init(_ result:Int32) {
        switch result {
        case 1:
            self = .success
        default:
            self = .failure
        }
    }
}
