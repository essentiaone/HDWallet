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
    func getDecriptedKeyStore(passwordData: Data) throws -> String?
    func encodedData() throws -> Data
    init? (data: String, passwordData: Data) throws
    init? (keyStore: Data) throws

    init? (data: String, password: String) throws
    func getDecriptedKeyStore(password: String) throws -> String?
}
