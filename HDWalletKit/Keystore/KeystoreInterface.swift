//
//  KeystoreInterface.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 20.08.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public enum KeystoreError: Error {
    case keyDerivationError
    case aesError
}

protocol KeystoreInterface {
    func getDecriptedKeyStore(passwordData: Data) throws -> Data?
    func encodedData() throws -> Data
    init? (data: Data, passwordData: Data) throws
    init? (keyStore: Data) throws

    init? (data: Data, password: String) throws
    func getDecriptedKeyStore(password: String) throws -> Data?
}
