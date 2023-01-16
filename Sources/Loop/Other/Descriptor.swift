#if os(macOS) || os(iOS)
import Darwin.C
#elseif os(Linux)
import Glibc
#endif

public struct Descriptor: RawRepresentable, Sendable {
    public let rawValue: Int32

    public init?(rawValue: Int32) {
        guard rawValue >= 0 else {
            return nil
        }
        self.rawValue = rawValue
    }

    public var flags: Int32 {
        get { fcntl(rawValue, F_GETFD, 0) }
        nonmutating set { _ = fcntl(rawValue, F_SETFD, newValue) }
    }

    public var status: Int32 {
        get { fcntl(rawValue, F_GETFL, 0) }
        nonmutating set { _ = fcntl(rawValue, F_SETFL, newValue) }
    }
}

#if os(macOS) || os(iOS)
extension Descriptor {
    public static var maxLimit: Int {
        Int(OPEN_MAX)
    }
}
#elseif os(Linux)
extension Descriptor {
    public static var maxLimit: Int {
        var rlim = rlimit()
        guard getrlimit(Int32(RLIMIT_NOFILE.rawValue), &rlim) >= 0 else {
            return 0
        }
        return Int(rlim.rlim_max);
    }
}
#endif
