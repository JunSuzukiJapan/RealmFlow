//
//  RealmFlow+WriteOnly.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

//
//  RealmFlow
//    where RW = WriteOnly
//
public extension RealmFlow where RW: WriteOnly {
    /// Returns all objects of the given type stored in the Realm.
    ///
    /// - Parameter type: The type of the objects to be returned.
    /// - Returns: `ReadWrite` operation
    public func objects<T: Object, Raw>(_ type: T.Type) -> RealmRW<T, Results<T>, Raw> {
        return RealmRW<T, Results<T>, Raw> { realm in
            let _ = try! self._run(realm)
            return realm.objects(type)
        }
    }

    /// Returns all objects for a given class name in the Realm.
    ///
    /// - Parameter typeName: The class name of the objects to be returned.
    /// - Returns: `ReadWrite` operation
    public func dynamicObjects(_ typeName: String) -> RealmRW<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> {
        return RealmRW<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> { realm in
            let _ = try! self._run(realm)
            return ResultsWrapper(realm.dynamicObjects(typeName))
        }
    }
    
    /// Retrieves the single instance of a given object type with the given primary key from the Realm.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Parameter key:  The primary key of the desired object.
    /// - Returns: `ReadWrite` operation
    public func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> RealmRW<T?, T?, RawObject> {
        return RealmRW<T?, T?, RawObject> { realm in
            let _ = try! self._run(realm)
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
}

// WriteOnly時には,subscribeするものがないので、subscribeなどの呼び出しはエラーになる。
//    subscribe, sorted, filterの３つのメソッドをここで定義しておかないと、
//    ReadOnly & ReadWrite時に呼び出す時に、どのメソッドを使うのかの推論がうまくいかないようだ。
public extension RealmFlow where RW: WriteOnly, T: Object {
    public func subscribe(onNext: @escaping (Results<T>) -> ()) throws -> RealmWO<T> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    public func subscribe_with_write_permission(onNext: @escaping (Realm, Results<T>) -> ()) throws -> RealmWO<T> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }

    public func subscribe_opt(onNext: @escaping (T?) -> ()) throws -> RealmRO<T?, T?, RawObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    public func subscribe_opt_with_write_permission(onNext: @escaping (Realm, T?) -> ()) throws -> RealmRW<T?, T?, RawObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }

    public func sorted(_ by: @escaping (T, T) throws -> Bool) throws -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call sorted with no data", code: -1, userInfo: nil)
    }
    
    public func filter(_ predicate: @escaping (T) -> Bool) throws -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call filter with no data", code: -1, userInfo: nil)
    }
}
