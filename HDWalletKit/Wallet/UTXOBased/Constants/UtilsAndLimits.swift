//
//  UtilsAndLimits.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 1/6/19.
//  Copyright © 2019 Essentia. All rights reserved.
//

import Foundation

// P2SH BIP16 didn't become active until Apr 1 2012. All txs before this timestamp should not be verified with P2SH rule.
let BTC_BIP16_TIMESTAMP: UInt32 = 1_333_238_400

// Scripts longer than 10000 bytes are invalid.
let BTC_MAX_SCRIPT_SIZE: Int = 10_000

// Maximum number of bytes per "pushdata" operation
let BTC_MAX_SCRIPT_ELEMENT_SIZE: Int = 520; // bytes

// Number of public keys allowed for OP_CHECKMULTISIG
let BTC_MAX_KEYS_FOR_CHECKMULTISIG: Int = 20

// Maximum number of operations allowed per script (excluding pushdata operations and OP_<N>)
// Multisig op additionally increases count by a number of pubkeys.
let BTC_MAX_OPS_PER_SCRIPT: Int = 201

let BTC_LOCKTIME_THRESHOLD: UInt32 = 500_000_000
