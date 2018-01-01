//
//  Wallet.swift
//  WalletKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public final class Wallet: WalletType {
    private let mnemonicManager: MnemonicManager
    
    public init(wordList: WordList) {
        mnemonicManager = MnemonicManager(wordList: wordList)
    }
    
    public func createMnemonic(fromEntropyString entropyString: String) -> String {
        return mnemonicManager.createMnemonic(fromEntropyString: entropyString)
    }
    
    public func createSeedString(fromMnemonic mnemonic: String, withPassphrase passphrase: String) -> String {
        return mnemonicManager.createSeedString(fromMnemonic: mnemonic, withPassphrase: passphrase)
    }
}
