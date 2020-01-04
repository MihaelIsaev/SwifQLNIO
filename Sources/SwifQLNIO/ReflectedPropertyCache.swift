import Foundation
import NIO

/// Caches derived `ReflectedProperty`s so that they only need to be decoded once per thread.
final class ReflectedPropertyCache {
    /// Thread-specific shared storage.
    static var storage: [AnyKeyPath: ReflectedProperty] {
        get {
            let cache = ReflectedPropertyCache.thread.currentValue ?? .init()
            return cache.storage
        }
        set {
            let cache = ReflectedPropertyCache.thread.currentValue ?? .init()
            cache.storage = newValue
            ReflectedPropertyCache.thread.currentValue = cache
        }
    }
    
    /// Private `ThreadSpecificVariable` powering this cache.
    private static let thread: ThreadSpecificVariable<ReflectedPropertyCache> = .init()
    
    /// Instance storage.
    private var storage: [AnyKeyPath: ReflectedProperty]
    
    /// Creates a new `ReflectedPropertyCache`.
    init() {
        self.storage = [:]
    }
}
