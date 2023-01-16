public enum IO: Sendable {
    case read, write
}

protocol PollerProtocol {
    var descriptor: Descriptor { get }
    mutating func poll(deadline: Instant?) throws -> ArraySlice<Event>
    mutating func add(socket: Descriptor, event: IO)
    mutating func remove(socket: Descriptor, event: IO)
}

extension PollerProtocol {
    mutating func clear(socket: Descriptor) {
        remove(socket: socket, event: .read)
        remove(socket: socket, event: .write)
    }
}
