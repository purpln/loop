#if os(macOS) || os(iOS)
import Darwin.C
#elseif os(Linux)
import Glibc
#endif

public struct SystemError: Error, Equatable {
    public let code: Int

    public init(_ code: Int = .init(errno)) {
        self.code = code
    }
}

extension SystemError: CustomStringConvertible {
    public var description: String { .init(cString: strerror(errno)) }
}
