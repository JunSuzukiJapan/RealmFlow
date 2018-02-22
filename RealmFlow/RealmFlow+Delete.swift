//
//  RealmFlow+Delete.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

//
// WriteOnly
//
public extension RealmFlow where RW: WriteOnly {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `WriteOnly` operation
    public func delete(_ object: Object) -> RealmWO<Void> {
        return RealmWO<Void> { realm in
            let _ = try self._run(realm)
            realm.delete(object)
        }
    }
    
    /// Deletes queried object in the Realm.
    /// Always throw an exception
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `WriteOnly` operation
    public func delete() throws -> RealmRW<T, Void, NoObject> {
        throw NSError(domain: "cannot call delete() when no object queried.", code: -1, userInfo: nil)
    }

    /// Delete all queried objects in the Realm.
    /// Always throw an exception
    ///
    /// - Returns: `WriteOnly` operation
    public func deleteAll() throws -> RealmWO<Void> {
        throw NSError(domain: "cannot call deleteAll() when no object queried.", code: -1, userInfo: nil)
    }
}

//
// ReadOnly
//
public extension RealmFlow where RW: ReadOnly {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete(_ object: Object) -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let _ = try self._run(realm)
            realm.delete(object)
        }
    }
}

/*
 * This section can not compile by XCode 9.2.
 *
public extension RealmFlow where RW: ReadOnly, T: Object, ROW: RawObject {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let result: T? = try self._run(realm) as? T
            if let object = result {
                realm.delete(object)
            }
        }
    }
}


public extension RealmFlow where RW: ReadOnly, T: Object, U: Results<T>, ROW: RawResults {
    /// Delete all queried objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let results = try self._run(realm)
            for object in results {
                realm.delete(object)
            }
        }
    }
}

public extension RealmFlow where RW: ReadOnly, T: Object, U: SequenceWrapper<T>, ROW: Wrap {
    /// Delete all queried objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let results = try self._run(realm)
            for object in results {
                realm.delete(object)
            }
        }
    }
}
*/

//
// ReadWrite
//
public extension RealmFlow where RW: ReadWrite {
    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete(_ object: Object) -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let _ = try self._run(realm)
            realm.delete(object)
        }
    }
}

/*
 * This section can not compile by XCode 9.2.
 *
 public extension RealmFlow where RW: ReadWrite, T: Object, ROW: RawObject {
    /// Deletes queried object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `ReadWrite` operation
    public func delete() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let result: T? = try self._run(realm) as? T
            if let object = result {
                realm.delete(object)
            }
        }
    }
}

public extension RealmFlow where RW: ReadWrite, T: Object, U: Results<T>, ROW: RawResults {
    /// Delete all queried objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let results = try self._run(realm)
            for object in results {
                realm.delete(object)
            }
        }
    }
}

public extension RealmFlow where RW: ReadWrite, T: Object, U: SequenceWrapper<T>, ROW: Wrap {
    /// Delete all queried objects in the Realm.
    ///
    /// - Returns: `ReadWrite` operation
    public func deleteAll() -> RealmRW<T, Void, NoObject> {
        return RealmRW<T, Void, NoObject> { realm in
            let results = try self._run(realm)
            for object in results {
                realm.delete(object)
            }
        }
    }
}
*/
