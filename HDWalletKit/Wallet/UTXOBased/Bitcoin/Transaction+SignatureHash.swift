//
//  Transaction+SignatureHash.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 2/5/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

private let zero: Data = Data(repeating: 0, count: 32)
private let one: Data = Data(repeating: 1, count: 1) + Data(repeating: 0, count: 31)

extension Transaction {
    internal func getPrevoutHash(hashType: SighashType) -> Data {
        if !hashType.isAnyoneCanPay {
            // If the ANYONECANPAY flag is not set, hashPrevouts is the double SHA256 of the serialization of all input outpoints
            let serializedPrevouts: Data = inputs.reduce(Data()) { $0 + $1.previousOutput.serialized() }
            return serializedPrevouts.doubleSHA256
        } else {
            // if ANYONECANPAY then uint256 of 0x0000......0000.
            return zero
        }
    }
    
    internal func getSequenceHash(hashType: SighashType) -> Data {
        if !hashType.isAnyoneCanPay
            && !hashType.isSingle
            && !hashType.isNone {
            // If none of the ANYONECANPAY, SINGLE, NONE sighash type is set, hashSequence is the double SHA256 of the serialization of nSequence of all inputs
            let serializedSequence: Data = inputs.reduce(Data()) { $0 + $1.sequence }
            return serializedSequence.doubleSHA256
        } else {
            // Otherwise, hashSequence is a uint256 of 0x0000......0000
            return zero
        }
    }
    
    internal func getOutputsHash(index: Int, hashType: SighashType) -> Data {
        if !hashType.isSingle
            && !hashType.isNone {
            // If the sighash type is neither SINGLE nor NONE, hashOutputs is the double SHA256 of the serialization of all output amounts (8-byte little endian) paired up with their scriptPubKey (serialized as scripts inside CTxOuts)
            let serializedOutputs: Data = outputs.reduce(Data()) { $0 + $1.serialized() }
            return serializedOutputs.doubleSHA256
        } else if hashType.isSingle && index < outputs.count {
            // If sighash type is SINGLE and the input index is smaller than the number of outputs, hashOutputs is the double SHA256 of the output amount with scriptPubKey of the same index as the input
            let serializedOutput = outputs[index].serialized()
            return serializedOutput.doubleSHA256
        } else {
            // Otherwise, hashOutputs is a uint256 of 0x0000......0000.
            return zero
        }
    }
    
    internal func signatureHashLegacy(for utxo: TransactionOutput, inputIndex: Int, hashType: SighashType) -> Data {
        // If inputIndex is out of bounds, BitcoinABC is returning a 256-bit little-endian 0x01 instead of failing with error.
        guard inputIndex < inputs.count else {
            //  tx.inputs[inputIndex] out of range
            return one
        }
        
        // Check for invalid use of SIGHASH_SINGLE
        guard !(hashType.isSingle && inputIndex < outputs.count) else {
            //  tx.outputs[inputIndex] out of range
            return one
        }
        
        // Transaction is struct(value type), so it's ok to use self as an arg
        let txSigSerializer = BitcoinTransactionSignatureSerializer(tx: self, utxo: utxo, inputIndex: inputIndex, hashType: hashType)
        var data: Data = txSigSerializer.serialize()
        data += UInt32(hashType)
        let hash = data.doubleSHA256
        return hash
    }
    
    public func signatureHash(for utxo: TransactionOutput, inputIndex: Int, hashType: SighashType) -> Data {
        // If hashType doesn't have a fork id, use legacy signature hash
        guard hashType.hasForkId else {
            return signatureHashLegacy(for: utxo, inputIndex: inputIndex, hashType: hashType)
        }
        
        // "txin" ≒ "utxo"
        // "txin" is an input of this tx
        // "utxo" is an output of the prev tx
        // Currently not handling "inputIndex is out of range error" because BitcoinABC implementation is not handling this.
        let txin = inputs[inputIndex]
        
        var data = Data()
        // 1. nVersion (4-byte)
        data += version
        // 2. hashPrevouts
        data += getPrevoutHash(hashType: hashType)
        // 3. hashSequence
        data += getSequenceHash(hashType: hashType)
        // 4. outpoint [of the input txin]
        data += txin.previousOutput.serialized()
        // 5. scriptCode [of the input txout]
        data += utxo.scriptCode()
        // 6. value [of the input txout] (8-byte)
        data += utxo.value
        // 7. nSequence [of the input txin] (4-byte)
        data += txin.sequence
        // 8. hashOutputs
        data += getOutputsHash(index: inputIndex, hashType: hashType)
        // 9. nLocktime (4-byte)
        data += lockTime
        // 10. Sighash types [This time input] (4-byte)
        data += UInt32(hashType)
        let hash = data.doubleSHA256
        return hash
    }
}
