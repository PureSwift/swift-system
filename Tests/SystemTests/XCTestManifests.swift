#if !canImport(ObjectiveC)
import XCTest

extension ErrnoTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ErrnoTest = [
        ("testConstants", testConstants),
        ("testPatternMatching", testPatternMatching),
    ]
}

extension FileDescriptorTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileDescriptorTest = [
        ("testConstants", testConstants),
        ("testStandardDescriptors", testStandardDescriptors),
    ]
}

extension FileOperationsTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FileOperationsTest = [
        ("testAdHocOpen", testAdHocOpen),
        ("testAdHocPipe", testAdHocPipe),
        ("testGithubIssues", testGithubIssues),
        ("testHelpers", testHelpers),
        ("testSyscalls", testSyscalls),
    ]
}

extension FilePathComponentsTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FilePathComponentsTest = [
        ("testAdHocRRC", testAdHocRRC),
        ("testCases", testCases),
        ("testSeparatorNormalization", testSeparatorNormalization),
    ]
}

extension FilePathParsingTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FilePathParsingTest = [
        ("testNormalization", testNormalization),
    ]
}

extension FilePathSyntaxTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FilePathSyntaxTest = [
        ("testAdHocMutations", testAdHocMutations),
        ("testFailableStringInitializers", testFailableStringInitializers),
        ("testLexicallyRelative", testLexicallyRelative),
        ("testPartialWindowsRoots", testPartialWindowsRoots),
        ("testPathSyntax", testPathSyntax),
        ("testPrefixSuffix", testPrefixSuffix),
    ]
}

extension FilePathTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FilePathTest = [
        ("testFilePath", testFilePath),
    ]
}

extension FilePermissionsTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FilePermissionsTest = [
        ("testPermissions", testPermissions),
    ]
}

extension InternetProtocolTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InternetProtocolTests = [
        ("testAddress", testAddress),
        ("testInvalidIPv4Address", testInvalidIPv4Address),
        ("testInvalidIPv6Address", testInvalidIPv6Address),
        ("testIPv4Address", testIPv4Address),
        ("testIPv6Address", testIPv6Address),
    ]
}

extension MockingTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockingTest = [
        ("testMocking", testMocking),
    ]
}

extension SystemCharTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SystemCharTest = [
        ("testIsLetter", testIsLetter),
    ]
}

extension SystemStringTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SystemStringTest = [
        ("testAdHoc", testAdHoc),
        ("testPlatformString", testPlatformString),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ErrnoTest.__allTests__ErrnoTest),
        testCase(FileDescriptorTest.__allTests__FileDescriptorTest),
        testCase(FileOperationsTest.__allTests__FileOperationsTest),
        testCase(FilePathComponentsTest.__allTests__FilePathComponentsTest),
        testCase(FilePathParsingTest.__allTests__FilePathParsingTest),
        testCase(FilePathSyntaxTest.__allTests__FilePathSyntaxTest),
        testCase(FilePathTest.__allTests__FilePathTest),
        testCase(FilePermissionsTest.__allTests__FilePermissionsTest),
        testCase(InternetProtocolTests.__allTests__InternetProtocolTests),
        testCase(MockingTest.__allTests__MockingTest),
        testCase(SystemCharTest.__allTests__SystemCharTest),
        testCase(SystemStringTest.__allTests__SystemStringTest),
    ]
}
#endif
