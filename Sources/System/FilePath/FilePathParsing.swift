/*
 This source file is part of the Swift System open source project

 Copyright (c) 2020 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

// FIXME: Need to rewrite and simplify this code now that SystemString
// manages (and hides) the null terminator

// The separator we use internally
private var genericSeparator: SystemChar { .slash }

// The platform preferred separator
//
// TODO: Make private
internal var platformSeparator: SystemChar {
  _windowsPaths ? .backslash : genericSeparator
}

// Whether the character is the canonical separator
// TODO: Make private
internal func isSeparator(_ c: SystemChar) -> Bool {
  c == platformSeparator
}

// Whether the character is a pre-normalized separator
internal func isPrenormalSeparator(_ c: SystemChar) -> Bool {
  c == genericSeparator || c == platformSeparator
}

// Separator normalization, checking, and root parsing is internally hosted
// on SystemString for ease of unit testing.

extension SystemString {
  // For invariant enforcing/checking. Should always return false on
  // a fully-formed path
  fileprivate func _hasTrailingSeparator() -> Bool {
    // Just a root: do nothing
    guard _relativePathStart != endIndex else { return false }
    assert(!isEmpty)

    return isSeparator(self.last!)
  }

  // Enforce invariants by removing a trailing separator.
  //
  // Precondition: There is exactly zero or one trailing slashes
  //
  // Postcondition: Path is root, or has no trailing separator
  internal mutating func _removeTrailingSeparator() {
    if _hasTrailingSeparator() {
      self.removeLast()
      assert(!_hasTrailingSeparator())
    }
  }

  // Enforce invariants by normalizing the internal separator representation.
  //
  // 1) Normalize all separators to platform-preferred separator
  // 2) Drop redundant separators
  // 3) Drop trailing separators
  //
  // On Windows, UNC and device paths are allowed to begin with two separators,
  // and partial or mal-formed roots are completed.
  //
  // The POSIX standard does allow two leading separators to
  // denote implementation-specific handling, but Darwin and Linux
  // do not treat these differently.
  //
  internal mutating func _normalizeSeparators() {
    guard !isEmpty else { return }
    var (writeIdx, readIdx) = (startIndex, startIndex)

    if _windowsPaths {
      // Normalize forwards slashes to backslashes.
      //
      // NOTE: Ideally this would be done as part of separator coalescing
      // below. However, prenormalizing roots such as UNC paths requires
      // parsing and (potentially) fixing up semi-formed roots. This
      // normalization reduces the complexity of the task by allowing us to
      // use a read-only lexer.
      self._replaceAll(genericSeparator, with: platformSeparator)

      // Windows roots can have meaningful repeated backslashes or may
      // need backslashes inserted for partially-formed roots. Delegate that to
      // `_prenormalizeWindowsRoots` and resume.
      readIdx = _prenormalizeWindowsRoots()
      writeIdx = readIdx
    } else {
      assert(genericSeparator == platformSeparator)
    }

    while readIdx < endIndex {
      assert(writeIdx <= readIdx)

      // Swap and advance our indices.
      let wasSeparator = isSeparator(self[readIdx])
      self.swapAt(writeIdx, readIdx)
      self.formIndex(after: &writeIdx)
      self.formIndex(after: &readIdx)

      while wasSeparator, readIdx < endIndex, isSeparator(self[readIdx]) {
        self.formIndex(after: &readIdx)
      }
    }
    self.removeLast(self.distance(from: writeIdx, to: readIdx))
    self._removeTrailingSeparator()
  }
}

// @available(macOS 10.16, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath {
  internal mutating func _removeTrailingSeparator() {
    _storage._removeTrailingSeparator()
  }

  internal mutating func _normalizeSeparators() {
    _storage._normalizeSeparators()
  }

}

extension SystemString {
  internal var _relativePathStart: Index {
    _parseRoot().relativeBegin
  }
}

extension FilePath {
  internal var _relativeStart: SystemString.Index {
    _storage._relativePathStart
  }
  internal var _hasRoot: Bool {
    _relativeStart != _storage.startIndex
  }
}

// Parse separators

extension FilePath {
  internal typealias _Index = SystemString.Index

  // Parse a component that starts at `i`. Returns the end
  // of the component and the start of the next. Parsing terminates
  // at the index of the null byte.
  internal func _parseComponent(
    startingAt i: _Index
  ) -> (componentEnd: _Index, nextStart: _Index) {
    assert(i < _storage.endIndex)
    // Parse the root
    if i == _storage.startIndex {
      let relativeStart = _relativeStart
      if i != relativeStart {
        return (relativeStart, relativeStart)
      }
    }

    assert(!isSeparator(_storage[i]))
    guard let nextSep = _storage[i...].firstIndex(where: isSeparator) else {
      return (_storage.endIndex, _storage.endIndex)
    }
    return (nextSep, _storage.index(after: nextSep))
  }

  // Parse a component prior to the one that starts at `i`. Returns
  // the start of the prior component. If `i` is the index of null,
  // returns the last component.
  internal func _parseComponent(
    priorTo i: _Index
  ) -> Range<_Index> {
    precondition(i > _storage.startIndex)
    let relStart = _relativeStart

    if i == relStart { return _storage.startIndex..<relStart }
    assert(i > relStart)

    var slice = _storage[..<i]
    if i != _storage.endIndex {
      assert(isSeparator(slice.last!))
      slice.removeLast()
    }
    let end = slice.endIndex
    while slice.endIndex != relStart, let c = slice.last, !isSeparator(c) {
      slice.removeLast()
    }

    return slice.endIndex ..< end
  }

  internal func _isCurrentDirectory(_ component: Range<_Index>) -> Bool {
    _storage[component].elementsEqual([.dot])
  }

  internal func _isParentDirectory(_ component: Range<_Index>) -> Bool {
    _storage[component].elementsEqual([.dot, .dot])
  }

  internal func _isSpecialDirectory(_ component: Range<_Index>) -> Bool {
    _isCurrentDirectory(component) || _isParentDirectory(component)
  }
}

extension SystemString {
  internal func _parseRoot() -> (
    rootEnd: Index, relativeBegin: Index
  ) {
    guard !isEmpty else { return (startIndex, startIndex) }

    // Windows roots are more complex
    if _windowsPaths { return _parseWindowsRoot() }

    // A leading `/` is a root
    guard isSeparator(self.first!) else { return (startIndex, startIndex) }

    let next = self.index(after: startIndex)
    return (next, next)
  }
}

extension FilePath {
  internal var _portableDescription: String {
    guard _windowsPaths else { return description }
    let utf8 = description.utf8.map { $0 == UInt8(ascii: #"\"#) ? UInt8(ascii: "/") : $0 }
    return String(decoding: utf8, as: UTF8.self)
  }
}

// Whether we are providing Windows paths
@_implementationOnly import var SystemInternals.forceWindowsPaths
@inline(__always)
internal var _windowsPaths: Bool {
  #if os(Windows)
  return true
  #else
  return forceWindowsPaths
  #endif
}

extension FilePath {
  // Whether we should add a separator when doing an append
  internal var _needsSeparatorForAppend: Bool {
    guard let last = _storage.last, !isSeparator(last) else { return false }

    // On Windows, we can have a path of the form `C:` which is a root and
    // does not need a separator after it
    if _windowsPaths && _relativeStart == _storage.endIndex {
      return false
    }

    return true
  }
}

// MARK: - Invariants
extension FilePath {
  internal func _invariantCheck() {
    #if DEBUG
    var normal = self
    normal._normalizeSeparators()
    precondition(self == normal)
    precondition(!self._storage._hasTrailingSeparator())
    #endif // DEBUG
  }
}
