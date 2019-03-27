[![Build Status](https://travis-ci.com/essentiaone/HDWallet.svg?branch=develop)](https://travis-ci.com/essentiaone/HDWallet)
[![Black Duck Security Risk](https://copilot.blackducksoftware.com/github/repos/essentiaone/HDWallet/branches/develop/badge-risk.svg)](https://copilot.blackducksoftware.com/github/repos/essentiaone/HDWallet/branches/develop)
[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/HDWalletKit/badge.png)](https://cocoadocs.org/docsets/HDWalletKit)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/HDWalletKit/badge.svg)](https://cocoadocs.org/docsets/HDWalletKit)
[![Badge w/ Licence](https://cocoapod-badges.herokuapp.com/l/HDWalletKit/badge.svg)](https://cocoadocs.org/docsets/HDWalletKit)

# HDWalletKit
HDWalletKit is a Swift framwork that enables you to create and use bitcoin HD wallet ([Hierarchical Deterministic Wallets](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)) in your own app.

You can check if the address generation is working right [here](https://iancoleman.io/bip39/).

## Features
- HD and NonHD wallets support
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- Keystore generation
- Read keystore file
- Sign ether transaction
- ERC20 Tokens
- Sign UTXO based transaction

## Installation
### CocoaPods
<p>To integrate HDWalletKit into your Xcode project using <a href="http://cocoapods.org">CocoaPods</a>, specify it in your <code>Podfile</code>:</p>
<pre><code class="ruby language-ruby">pod 'HDWalletKit'</code></pre>

### Carthage
To install with [Carthage](https://github.com/Carthage/Carthage), simply add this in your `Cartfile`:
```ruby
github "essentiaone/HDWallet"
```
## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
## How to use
#### Generate seed and convert it to mnemonic sentence.
```swift
let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
let mnemonic = Mnemonic.create(entropy: entropy)
print(mnemonic)
// abandon amount liar amount expire adjust cage candy arch gather drum buyer

let seed = Mnemonic.createSeed(mnemonic: mnemonic)
print(seed.toHexString())
```
#### PrivateKey and key derivation (BIP39)

```swift
let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)
let privateKey = PrivateKey(seed: seed, coin: .bitcoin)

// BIP44 key derivation
// m/44'
let purpose = privateKey.derived(at: .hardened(44))

// m/44'/0'
let coinType = purpose.derived(at: .hardened(0))

// m/44'/0'/0'
let account = coinType.derived(at: .hardened(0))

// m/44'/0'/0'/0
let change = account.derived(at: .notHardened(0))

// m/44'/0'/0'/0/0
let firstPrivateKey = change.derived(at: .notHardened(0))
print(firstPrivateKey.publicKey.address)
```
#### Generate keystore file
```swift
let data = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
let keystore = try! KeystoreV3(data: data, password: "qwertyui")
let encodedKeystoreDaya = (try? keystore?.encodedData())
```
#### Open keystore file
```swift
let keystore = try! KeystoreV3(data: encodedKeystoreDaya, password: password)
guard let decoded = try? keystore?.getDecriptedKeyStore(password: password) else {
fatalError()
}
print(decoded)
```
#### Create your wallet and generate address
```swift
let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)
let network: Network = .main(.bitcoin)
let wallet = Wallet(seed: seed, network: network)
let account = wallet.generateAccount()
print(account)
```
#### Sign Ethereum transaction by private key
```swift
let signer = EIP155Signer()
let rawTransaction1 = EthereumRawTransaction(
    value: Wei("10000000000000000")!,
    to: "0x34205555576717bBdF8158E2b2c9ed64EB1e6B85",
    gasPrice: 99000000000,
    gasLimit: 21000,
    nonce: 2
)
guard let signed = try? signer.hash(rawTransaction: rawTransaction1).toHexString() else { return }
print(signed)
```

#### Sign Bitcoin transaction by private key
For getting UTXO you can use (https://github.com/essentiaone/essentia-bridges-api-ios)
```swift
let address = try LegacyAddress("1HLqrFX5fYwKriU7LRKMQGhwpz5HuszjnK", coin: .bitcoin)
let utxoWallet = UTXOWallet(privateKey: "Kz9UKkL6bKE92QPxQbPcqkCZTnCyLVyfRNFRSbToNjyb4bx321fh")
let signedTx = try utxoWallet.createTransaction(to: address, amount: 0, utxos: utxos)
```

#### Create send ERC20 tokens transaction data 
```swift
let erc20Token = ERC20(contractAddress: "0x8f0921f30555624143d427b340b1156914882c10", decimal: 18, symbol: "ESS")
let address = "0x2f5059f64D5C0c4895092D26CDDacC58751e0C3C"
let data = try! erc20Token.generateDataParameter(toAddress: address, amount: "3") 
```
#### Create get balance ERC20 token transaction data 
```swift
let erc20Token = ERC20(contractAddress: "0x8f0921f30555624143d427b340b1156914882c10", decimal: 18, symbol: "ESS")
let data = try! erc20Token.generateGetBalanceParameter(toAddress: "2f5059f64D5C0c4895092D26CDDacC58751e0C3C")
```
#### Convert non HD PrivateKey to Address
```swift
let privateKey = PrivateKey(pk: "L35qaFLpbCc9yCzeTuWJg4qWnTs9BaLr5CDYcnJ5UnGmgLo8JBgk", coin: .bitcoin)
print(privateKey.publicKey.address)
//128BCBZndgrPXzEgF4QbVR3jnQGwzRtEz5
```

## License
WalletKit is released under the [MIT License](https://github.com/essentiaone/HDWallet/blob/develop/LICENSE.md).
