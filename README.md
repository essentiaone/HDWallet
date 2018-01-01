# WalletKit
WalletKit is a Swift framwork that enables you to create and use bitcoin HD wallet([Hierarchical Deterministic Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)) in your own app.

## TODO
- [ ] Implement BIP39([Mnemonic code for generating deterministic keys](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) )
  - [ ] Add tests
- [ ] Implement BIP32([Hierarchical Deterministic Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki))
  - [ ] Add tests
- [ ] Set up CI

## How to use

- Create the instance of Wallet.
```swift
let wallet = Wallet(wordList: .english)
```

### Mnemonic sentence
- Just provide an entropy for a mnemonic sentence, or mnemonic sentence for a root seed.

```swift
// Provide entropy to generate mnemonic sentence from.        
let entropy = "000102030405060708090a0b0c0d0e0f"
let mnemonic = wallet.createMnemonic(fromEntropyString: entropy)

print(mnemonic)
// abandon amount liar amount expire adjust cage candy arch gather drum buyer

// Provide mnemonic sentence to generate root seed from.
let seed = wallet.createSeedString(fromMnemonic: mnemonic)

print(seed)
// 3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0
```
