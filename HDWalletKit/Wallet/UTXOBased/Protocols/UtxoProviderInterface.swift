//
//  UtxoProvider.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public protocol UtxoProviderInterface {
    func reload(address: Address, completion: @escaping (([UnspentTransaction]) -> Void))
    
    // List cached utxos
//    var cached: [UnspentTransaction] { get }
}
