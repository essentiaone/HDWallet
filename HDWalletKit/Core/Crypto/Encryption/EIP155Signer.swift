import CryptoSwift

public struct EIP155Signer {
    
    public init(chainId: Int) {
        self.chainId = chainId
    }
    
    private let chainId: Int
    
    public func sign(_ rawTransaction: EthereumRawTransaction, privateKey: PrivateKey) throws -> Data {
        let transactionHash = try hash(rawTransaction: rawTransaction)
        let signature = try privateKey.sign(hash: transactionHash)
        return try signTransaction(signature: signature, rawTransaction: rawTransaction)
    }
    
    public func sign(_ rawTransaction: EthereumRawTransaction, privateKey: Data) throws -> Data {
        let transactionHash = try hash(rawTransaction: rawTransaction)
        let signature = try Crypto.sign(transactionHash, privateKey: privateKey)
        return try signTransaction(signature: signature, rawTransaction: rawTransaction)
    }
    
    private func signTransaction(signature: Data, rawTransaction: EthereumRawTransaction) throws -> Data {
        let (r, s, v) = calculateRSV(signature: signature)
        return try RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
    }
    
    public func hash(rawTransaction: EthereumRawTransaction) throws -> Data {
        return Crypto.sha3keccak256(data: try encode(rawTransaction: rawTransaction))
    }
    
    public func encode(rawTransaction: EthereumRawTransaction) throws -> Data {
        var toEncode: [Any] = [
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data]
        if chainId != 0 {
            toEncode.append(contentsOf: [chainId, 0, 0 ]) // EIP155
        }
        return try RLP.encode(toEncode)
    }
    
    public func calculateRSV(signature: Data) -> (r: BInt, s: BInt, v: BInt) {
        return (
            r: BInt(str: signature[..<32].toHexString(), radix: 16)!,
            s: BInt(str: signature[32..<64].toHexString(), radix: 16)!,
            v: BInt(signature[64]) + (chainId == 0 ? 27 : (35 + 2 * chainId))
        )
    }
    
    public func calculateSignature(r: BInt, s: BInt, v: BInt) -> Data {
        let isOldSignitureScheme = [27, 28].contains(v)
        let suffix = isOldSignitureScheme ? v - 27 : v - 35 - 2 * chainId
        let sigHexStr = hex64Str(r) + hex64Str(s) + suffix.asString(withBase: 16)
        return Data(hex: sigHexStr)
    }
    
    private func hex64Str(_ i: BInt) -> String {
        let hex = i.asString(withBase: 16)
        return String(repeating: "0", count: 64 - hex.count) + hex
    }
}
