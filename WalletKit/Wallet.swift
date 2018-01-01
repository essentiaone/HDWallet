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
        
        let mnemonic = "silk wing trigger hint resemble tennis physical taste age never baby crunch"
        let seed = mnemonicManager.createSeedString(fromMnemonic: mnemonic)
        print(seed == "1044ff52e8cffaef65424a9b4f052247344fc39b9bc1ce72a34ac0dff0923a638374b897a09a21662bc796df5c9086cd0e2456d763a03c80efb4ff6683041225")
    }
}
