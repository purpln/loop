#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin.C
#elseif os(Linux) || os(Android) || os(FreeBSD)
import Glibc
#endif

extension Loop {
    public enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case again           //EAGAIN
        case wouldBlock      //EWOULDBLOCK
        case inProgress      //EINPROGRESS
        case interrupted     //EINTR
        case badDescriptor   //EBADF
        case invalidArgument //EINVAL
        case connectionReset //ECONNRESET
        case alreadyInUse    //EADDRINUSE
        case system(Int32)
        
        init() {
            switch errno {
            case EAGAIN: self = .again
            case EWOULDBLOCK: self = .wouldBlock
            case EINPROGRESS: self = .inProgress
            case EINTR: self = .interrupted
            case EBADF: self = .badDescriptor
            case EINVAL: self = .invalidArgument
            case ECONNRESET: self = .connectionReset
            case EADDRINUSE: self = .alreadyInUse
            default: self = .system(errno)
            }
        }
        
        public var description: String {
            switch self {
            case .again: return String(cString: strerror(EAGAIN))
            case .wouldBlock: return String(cString: strerror(EWOULDBLOCK))
            case .inProgress: return String(cString: strerror(EINPROGRESS))
            case .interrupted: return String(cString: strerror(EINTR))
            case .badDescriptor: return String(cString: strerror(EBADF))
            case .invalidArgument: return String(cString: strerror(EINVAL))
            case .connectionReset: return String(cString: strerror(ECONNRESET))
            case .alreadyInUse: return String(cString: strerror(EADDRINUSE))
            case .system(let code): return String(cString: strerror(code))
            }
        }
    }
}
