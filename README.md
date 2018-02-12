# WalletKit
WalletKit is a Swift framwork that enables you to create and use bitcoin HD wallet([Hierarchical Deterministic Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)) in your own app.

You can check if the address generation is working right [here](https://iancoleman.io/bip39/).

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [BIP13](https://github.com/bitcoin/bips/blob/master/bip-0013.mediawiki) address format

## How to use

- Generate seed and convert it to mnemonic sentence.

```swift
let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
let mnemonic = Mnemonic.create(entropy: entropy)
print(mnemonic)
// abandon amount liar amount expire adjust cage candy arch gather drum buyer

let seed = Mnemonic.createSeed(mnemonic: mnemonic)
print(seed.toHexString())
```

- PrivateKey and key derivation (BIP32, BIP44)

```swift
let masterPrivateKey = PrivateKey(seed: seed, network: .main)

// m/44'
let purpose = masterPrivateKey.derived(at: 44, hardens: true)

// m/44'/60'
let coinType = purpose.derived(at: 60, hardens: true)

// m/44'/60'/0'
let account = coinType.derived(at: 0, hardens: true)

// m/44'/60'/0'/0
let change = account.derived(at: 0)

// m/44'/60'/0'/0
let firstPrivateKey = change.derived(at: 0)
print(firstPrivateKey.publicKey.address)
```


- Create your wallet and generate addresse

```swift
// It generates master key pair from the seed provided.
let wallet = Wallet(seed: seed, network: .main)

let firstAddress = wallet.generateAddress(at: 0)
print(firstAddress)

let secondAddress = wallet.generateAddress(at: 1)
print(secondAddress)

let thirdAddress = wallet.generateAddress(at: 2)
print(thirdAddress)
```

## License
EthereumKit is released under the [MIT License](LICENSE.md).
