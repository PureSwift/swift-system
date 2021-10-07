/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

/// Socket Address
public protocol SocketAddress {
    
    /// Socket Address Family
    static var family: SocketAddressFamily { get }
    
    func withUnsafeBytes<Result>(_ body: ((UnsafeRawBufferPointer) -> (Result))) -> Result
}

