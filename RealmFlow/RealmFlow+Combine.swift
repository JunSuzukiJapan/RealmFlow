//
//  RealmFlow+Combine.swift
//  RealmFlow
//
//  Created by jun suzuki on 2018/02/18.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation

public extension RealmFlow where RW: ReadOnly {
    public func combine(_ flow: RealmFlow<ReadOnly, T, U, ROW>) -> RealmRO<T, U, ROW> {
        return RealmRO<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    public func combine(_ flow: RealmFlow<WriteOnly, T, U, ROW>) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    public func combine(_ flow: RealmFlow<ReadWrite, T, U, ROW>) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

public extension RealmFlow where RW: WriteOnly {
    public func combine(_ flow: RealmFlow<ReadOnly, T, U, ROW>) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    public func combine(_ flow: RealmFlow<WriteOnly, T, U, ROW>) -> RealmWO<T, U, ROW> {
        return RealmWO<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
    
    public func combine(_ flow: RealmFlow<ReadWrite, T, U, ROW>) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

public extension RealmFlow where RW: ReadWrite {
    public func combine(_ flow: RealmFlow<RW, T, U, ROW>) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let _ = try self._run(realm)
            return try flow._run(realm)
        }
    }
}

