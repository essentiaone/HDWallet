//
//  WalletType.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public protocol WalletType {
    /// Generates a mnemonic sentence from an entropy string provided.
    ///
    /// - Parameter entropyString: An entropy string to generate mnemonic from. But the length must be of 16, 20, 24, 28 or 32.
    /// - Returns: Mnemonic sentence. The length could be any number from 3 to 24 in a multiple of 3. Most of the time 12 or 24.
    func createMnemonic(fromEntropyString entropyString: String) -> String
    
    /// Generates a seed from mnemonic sentence provided.
    ///
    /// - Parameters:
    ///   - mnemonic: Mnemonic sentence to generates a seed from.
    ///   - passphrase: Passphrase you set when created the mnemonic sentence.
    /// - Returns: Seed to recover the deterministic keys.
    func createSeedString(fromMnemonic mnemonic: String, withPassphrase passphrase: String) -> String
}

public extension WalletType {
    /// Generates a seed from mnemonic sentence provided.
    ///
    /// - Parameters:
    ///   - mnemonic: Mnemonic sentence to generates a seed from.
    /// - Returns: Seed to recover the deterministic keys.
    public func createSeedString(fromMnemonic mnemonic: String, withPassphrase passphrase: String = "") -> String {
        return createSeedString(fromMnemonic: mnemonic, withPassphrase: passphrase)
    }
}
