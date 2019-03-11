import Foundation
/// RawTransaction constructs necessary information to publish transaction.
public struct EthereumRawTransaction {
    
    /// Amount value to send, unit is in Wei
    public let value: Wei
    
    /// Address to send ether to
    public let to: EthereumAddress
    
    /// Gas price for this transaction, unit is in Wei
    /// you need to convert it if it is specified in GWei
    /// use Converter.toWei method to convert GWei value to Wei
    public let gasPrice: Int
    
    /// Gas limit for this transaction
    /// Total amount of gas will be (gas price * gas limit)
    public let gasLimit: Int
    
    /// Nonce of your address
    public let nonce: Int
    
    /// Data to attach to this transaction
    public let data: Data

    public init(value: Wei, to: String, gasPrice: Int, gasLimit: Int, nonce: Int, data: Data = Data()) {
        self.value = value
        self.to = EthereumAddress(string:to)
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.nonce = nonce
        self.data = data
    }
}
