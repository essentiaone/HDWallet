import CryptoSwift

public struct EIP155Signer {
    
    private let chainID: Int = 1
    
    public func sign(_ rawTransaction: EthereumRawTransaction, privateKey: PrivateKey) throws -> Data {
        let transactionHash = try hash(rawTransaction: rawTransaction)
        let signature = try privateKey.sign(hash: transactionHash)
        
        let (r, s, v) = calculateRSV(signature: signature)
        let encodingArray:[Any] = [
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ]
        return try RLP.encode(encodingArray)
    }
    
    public func hash(rawTransaction: EthereumRawTransaction) throws -> Data {
        return Crypto.sha3keccak256(data: try encode(rawTransaction: rawTransaction))
    }
    
    public func encode(rawTransaction: EthereumRawTransaction) throws -> Data {
        return try RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            chainID, 0, 0
        ])
    }
    
    public func calculateRSV(signature: Data) -> (r: BInt, s: BInt, v: BInt) {
        return (
            r: BInt(str: signature[..<32].toHexString(), radix: 16)!,
            s: BInt(str: signature[32..<64].toHexString(), radix: 16)!,
            v: BInt(signature[64]) + 35 + 2 * chainID
        )
    }

    public func calculateSignature(r: BInt, s: BInt, v: BInt) -> Data {
        let isOldSignatureScheme = [27, 28].contains(v)
        let suffix = isOldSignatureScheme ? v - 27 : v - 35 - 2 * chainID
        let sigHexStr = hex64Str(r) + hex64Str(s) + suffix.asString(withBase: 16)
        return Data(hex: sigHexStr)
    }

    private func hex64Str(_ i: BInt) -> String {
        let hex = i.asString(withBase: 16)
        return String(repeating: "0", count: 64 - hex.count) + hex
    }
}
