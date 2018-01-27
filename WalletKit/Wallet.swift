//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public final class Wallet: WalletType {
    
    private let mnemonicGenerator: MnemonicGeneratorType
    private var keyPairGenerator: KeyPairGeneratorType?
    
    public init(wordList: WordList) {
        mnemonicGenerator = MnemonicGenerator(wordList: wordList)
    }
    
    public func createMnemonic(fromEntropyString entropyString: String) -> String {
        return mnemonicGenerator.createMnemonic(fromEntropyString: entropyString)
    }
    
    public func createSeedString(fromMnemonic mnemonic: String, withPassphrase passphrase: String) -> String {
        return mnemonicGenerator.createSeedString(fromMnemonic: mnemonic, withPassphrase: passphrase)
    }
    
    public func initialize(seed: String, network: Network, hardensMasterKeyPair: Bool) {
        KeyPairGenerator.setup(seedString: seed, network: network, hardensMasterKeyPair: hardensMasterKeyPair)
        keyPairGenerator = KeyPairGenerator()
    }
}
