//
//  RealmFlow+Delete.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

public extension RealmFlow where RW: WriteOnly {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `WriteOnly` operation
    public func delete(_ object: Object) -> RealmWO<Void, ROW> {
        return RealmWO<Void, ROW> { realm in
            let _ = try self._run(realm)
            realm.delete(object)
        }
    }
    
    /// Delete all objects in the Realm.
    ///
    /// - Returns: `WriteOnly` operation
    public func deleteAll() -> RealmWO<Void, ROW> {
        return RealmWO<Void, ROW> { realm in
            let _ = try self._run(realm)
            realm.deleteAll()
        }
    }
}

public extension RealmFlow where RW: ReadOnly {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete(_ object: Object) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.delete(object)
            return read_result
        }
    }
    
    /// Delete all objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.deleteAll()
            return read_result
        }
    }
}

public extension RealmFlow where RW: ReadWrite {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete(_ object: Object) -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.delete(object)
            return read_result
        }
    }
    
    /// Delete all objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, U, ROW> {
        return RealmRW<T, U, ROW> { realm in
            let read_result = try self._run(realm)
            realm.deleteAll()
            return read_result
        }
    }
}

