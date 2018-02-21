//
//  RealmFlow+Add.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

public extension RealmFlow where RW: WriteOnly {
    /// Adds object into the Realm.
    ///
    /// - Parameter object: The object to be added to this Realm.
    /// - Returns: `WriteOnly` operation
    public func add(_ object: Object) -> RealmWO<Void> {
        return RealmWO<Void> { realm in
            let _ = try self._run(realm)
            realm.add(object)
        }
    }
}

public extension RealmFlow where RW: ReadOnly {
    /// Adds object into the Realm.
    ///
    /// - Parameter object: The object to be added to this Realm.
    /// - Returns: `ReadWrite` operation
    public func add(_ object: Object) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.add(object)
            return read_result
        }
    }
}

public extension RealmFlow where RW: ReadWrite {
    /// Adds object into the Realm.
    ///
    /// - Parameter object: The object to be added to this Realm.
    /// - Returns: `ReadWrite` operation
    public func add(_ object: Object) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.add(object)
            return read_result
        }
    }
}

