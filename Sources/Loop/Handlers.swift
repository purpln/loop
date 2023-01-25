internal struct Handlers {
    public var read: UnsafeContinuation<Void, Error>?
    public var write: UnsafeContinuation<Void, Error>?

    public var isEmpty: Bool { read == nil && write == nil }
}

internal extension UnsafeMutableBufferPointer where Element == Handlers {
    subscript(_ descriptor: Descriptor) -> Handlers {
        get { self[Int(descriptor.rawValue)] }
        set { self[Int(descriptor.rawValue)] = newValue }
    }

    static func allocate(repeating element: Handlers, count: Int) -> UnsafeMutableBufferPointer<Handlers> {
        let pointer = UnsafeMutablePointer<Handlers>.allocate(capacity: count)
        pointer.initialize(repeating: element, count: count)

        return UnsafeMutableBufferPointer(
            start: pointer,
            count: Descriptor.maxLimit)
    }
}
