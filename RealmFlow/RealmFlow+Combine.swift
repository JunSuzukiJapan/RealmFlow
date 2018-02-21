//
//  RealmFlow+Combine.swift
//  RealmFlow
//
//  Created by jun suzuki on 2018/02/18.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation

public extension RealmFlow where RW: ReadOnly {
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadOnly, V, W, X>) -> RealmRO<V, W, X> {
        return RealmRO<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<WriteOnly, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadWrite, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

public extension RealmFlow where RW: WriteOnly {
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadOnly, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<WriteOnly, V, W, X>) -> RealmFlow<WriteOnly, V, W, X> {
        return RealmFlow<WriteOnly, V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadWrite, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

public extension RealmFlow where RW: ReadWrite {
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadOnly, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<WriteOnly, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    /// Combine two operations.
    ///
    /// - parameter flow: Operation (RealmFlow object)
    /// - returns: Combined operation. (RealmFlow object)
    public func combine<V, W, X>(_ flow: RealmFlow<ReadWrite, V, W, X>) -> RealmRW<V, W, X> {
        return RealmRW<V, W, X> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

