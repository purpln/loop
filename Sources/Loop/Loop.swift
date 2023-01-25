public typealias Instant = ContinuousClock.Instant

public let loop: Loop = .init()

public actor Loop {
    private var poller: PollerProtocol = Poller()
    private var handlers: UnsafeMutableBufferPointer<Handlers>
    
    public var executing: Bool = true
    
    public init() {
        handlers = UnsafeMutableBufferPointer.allocate(repeating: Handlers(), count: Descriptor.maxLimit)
    }
    
    deinit {
        handlers.deallocate()
    }
    
    public func run(until timeout: Duration = .milliseconds(2)) async {
        executing = true
        do {
            repeat {
                try await loop.poll(deadline: .now.advanced(by: timeout))
                await Task.yield()
            } while executing
        } catch {
            print("poll error:", error)
        }
    }
    
    public func terminate() {
        executing = false
    }
    
    private func poll(deadline: Instant) throws {
        let events = try poller.poll(deadline: deadline)
        if events.count != 0 {
            scheduleReady(events)
        }
    }
    
    func scheduleReady(_ events: ArraySlice<Event>) {
        for event in events {
            let pair = handlers[event.descriptor]

            guard !pair.isEmpty else { continue }

            if event.typeOptions.contains(.read), let handler = pair.read {
                removeContinuation(for: event.descriptor, event: .read)
                handler.resume(returning: ())
            }

            if event.typeOptions.contains(.write), let handler = pair.write {
                removeContinuation(for: event.descriptor, event: .write)
                handler.resume(returning: ())
            }
        }
    }
    
    public func wait(for socket: Descriptor, event: IO, deadline: Instant?) async throws {
        try await withUnsafeThrowingContinuation { continuation in
            insertContinuation(continuation, for: socket, event: event, deadline: deadline)
        }
    }

    func insertContinuation(_ handler: UnsafeContinuation<Void, Swift.Error>, for descriptor: Descriptor, event: IO, deadline: Instant?) {
        switch event {
        case .read:
            guard handlers[descriptor].read == nil else {
                handler.resume(throwing: Loop.Error.alreadyInUse)
                return
            }
            handlers[descriptor].read = handler
        case .write:
            guard handlers[descriptor].write == nil else {
                handler.resume(throwing: Loop.Error.alreadyInUse)
                return
            }
            handlers[descriptor].write = handler
        }
        poller.add(socket: descriptor, event: event)
    }
    
    func removeContinuation(for descriptor: Descriptor, event: IO) {
        switch event {
        case .read: handlers[descriptor].read = nil
        case .write: handlers[descriptor].write = nil
        }
        poller.remove(socket: descriptor, event: event)
    }
}
