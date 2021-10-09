/*
 This source file is part of the Swift System open source project

 Copyright (c) 2021 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

internal protocol CSocketAddress {
    
    static var addressFamily: SocketAddressFamily { get }
    
    
}

internal extension CSocketAddress {
    
    @usableFromInline
    func withUnsafePointer<Result>(
        _ body: (UnsafePointer<CInterop.SocketAddress>, UInt32) throws -> Result
        ) rethrows -> Result {
        return try Swift.withUnsafeBytes(of: self) {
            return try body($0.baseAddress!.assumingMemoryBound(to:  CInterop.SocketAddress.self), UInt32(MemoryLayout<Self>.size))
        }
    }
}

extension CInterop.UnixSocketAddress: CSocketAddress {
    
    static var addressFamily: SocketAddressFamily { .unix }
}

extension CInterop.IPv4SocketAddress: CSocketAddress {
    
    static var addressFamily: SocketAddressFamily { .ipv4 }
}

extension CInterop.IPv6SocketAddress: CSocketAddress {
    
    static var addressFamily: SocketAddressFamily { .ipv6 }
}
