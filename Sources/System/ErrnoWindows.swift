/*
 This source file is part of the Swift System open source project

 Copyright (c) 2024 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

#if os(Windows)

import WinSDK

extension Errno {
  public init(windowsError: DWORD) {
    self.init(rawValue: mapWindowsErrorToErrno(windowsError))
  }
}

#endif
