#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin.C

extension Instant {
    private var kqueueMax: Duration {
        .seconds(60*60*24)
    }
    
    var timeout: timespec {
        guard self < .now + kqueueMax else {
            return timespec(
                tv_sec: Int(kqueueMax.components.seconds),
                tv_nsec: Int(kqueueMax.components.attoseconds / 1_000_000_000))
        }
        let duration = Self.now.duration(to: self)
        return timespec(
            tv_sec: Int(duration.components.seconds),
            tv_nsec: Int(duration.components.attoseconds / 1_000_000_000))
    }
}
#elseif os(Linux) || os(Android) || os(FreeBSD)
import Glibc

extension Instant {
    var timeout: Int32 {
        let duration = Self.now.duration(to: self)
        let timeout = duration.components.seconds * 1_000 + duration.components.attoseconds / 1_000_000_000_000_000
        guard timeout < Int(Int32.max) else {
            return Int32.max
        }
        return Int32(timeout)
    }
}
#endif
