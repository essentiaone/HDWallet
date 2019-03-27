//
//  UtxoTransactionSigner.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/19/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

public protocol UtxoTransactionSignerInterface {
    func sign(_ unsignedTransaction: UnsignedTransaction, with key: PrivateKey) throws -> Transaction
}
