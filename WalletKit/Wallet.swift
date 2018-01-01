//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public final class Wallet {
    private let keyGenerator: KeyGenerator
    private let mnemonicManager: MnemonicManager
    
    public init(network: Network, wordList: WordList = .english) {
        let seedString = "000102030405060708090a0b0c0d0e0f"
        keyGenerator = KeyGenerator(seedString: seedString, network: network)
        mnemonicManager = MnemonicManager(wordList: wordList)
        
        let mnemonicWords = mnemonicManager.createMnemonic(fromEntropyString: seedString)
        print(mnemonicWords)
    }
}
