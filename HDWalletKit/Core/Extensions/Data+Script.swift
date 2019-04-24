//
//  Data+Script.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 1/4/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

// swiftlint:disable shorthand_operator
// swiftlint:disable operator_whitespace

protocol BinaryConvertible {
    static func +(lhs: Data, rhs: Self) -> Data
    static func +=(lhs: inout Data, rhs: Self)
}

extension BinaryConvertible {
    static func +(lhs: Data, rhs: Self) -> Data {
        var value = rhs
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return lhs + data
    }
    
    static func +=(lhs: inout Data, rhs: Self) {
        lhs = lhs + rhs
    }
}

extension UInt16: BinaryConvertible {}
extension UInt64: BinaryConvertible {}
extension Int8: BinaryConvertible {}
extension Int16: BinaryConvertible {}
extension Int32: BinaryConvertible {}
extension Int64: BinaryConvertible {}
extension Int: BinaryConvertible {}

extension Bool: BinaryConvertible {
    static func +(lhs: Data, rhs: Bool) -> Data {
        return lhs + (rhs ? UInt8(0x01) : UInt8(0x00)).littleEndian
    }
}

extension String: BinaryConvertible {
    static func +(lhs: Data, rhs: String) -> Data {
        guard let data = rhs.data(using: .ascii) else { return lhs }
        return lhs + data
    }
}

func +(lhs: Data, rhs: OpCodeProtocol) -> Data {
    return lhs + rhs.value
}
func += (lhs: inout Data, rhs: OpCodeProtocol) {
    lhs = lhs + rhs
}

extension Data: BinaryConvertible {
    static func +(lhs: Data, rhs: Data) -> Data {
        var data = Data()
        data.append(lhs)
        data.append(rhs)
        return data
    }
}

extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { (ptr) -> T in
            return ptr.baseAddress!.assumingMemoryBound(to: T.self).pointee
        }
    }
    
    func to(type: String.Type) -> String {
        return String(bytes: self, encoding: .ascii)!.replacingOccurrences(of: "\0", with: "")
    }
    
    func to(type: VarInt.Type) -> VarInt {
        let value: UInt64
        let length = self[0..<1].to(type: UInt8.self)
        switch length {
        case 0...252:
            value = UInt64(length)
        case 0xfd:
            value = UInt64(self[1...2].to(type: UInt16.self))
        case 0xfe:
            value = UInt64(self[1...4].to(type: UInt32.self))
        case 0xff:
            fallthrough
        default:
            value = self[1...8].to(type: UInt64.self)
        }
        return VarInt(value)
    }
}

extension Data {
    public var hex: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}
