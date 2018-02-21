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
    public func objects<T: Object>(_ type: T.Type) -> RealmRW<T, Results<T>, RawResults> {
        return RealmRW<T, Results<T>, RawResults> { realm in
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
public extension RealmFlow where RW: WriteOnly, ROW: NoObject {

    /// Receive and process the latest data.
    /// Always throw an exception
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe(_ processor: @escaping () -> ()) throws -> RealmRO<Void, Void, NoObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and process the latest data with write permission.
    /// Always throw an exception
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_with_write_permission(_ processor: @escaping (Realm) -> ()) throws -> RealmRW<Void, Void, NoObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and sort the latest data.
    /// Always throw an exception
    ///
    /// - Parameter by: The method for comparing two objects.
    public func sorted(_ by: @escaping (T, T) throws -> Bool) throws -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and filter the latest data.
    /// Always throw an exception
    ///
    /// - Parameter predicate: The method for filtering object.
    public func filter(_ predicate: @escaping (T) -> Bool) throws -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
}

//
//  RealmFlow
//    where ReadOrWrapper = Wrapper
//
public extension RealmFlow where RW: WriteOnly, T: Object, U: SequenceWrapper<T>, ROW: Wrap {

    /// Receive and process the latest data.
    /// Always throw an exception
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe(_ processor: @escaping (SequenceWrapper<T>) -> ()) throws -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and process the latest data with write permission.
    /// Always throw an exception
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_with_write_permission(_ processor: @escaping (Realm, SequenceWrapper<T>) -> ()) throws -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and sort the latest data.
    /// Always throw an exception
    ///
    /// - Parameter by: The method for comparing two objects.
    public func sorted(_ by: @escaping (T, T) throws -> Bool) throws -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and filter the latest data.
    /// Always throw an exception
    ///
    /// - Parameter predicate: The method for filtering object.
    public func filter(_ predicate: @escaping (T) -> Bool) throws -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
}

//
//  RealmFlow
//    where ReadOrWrapper = RawObject
//
public extension RealmFlow where RW: WriteOnly, ROW: RawObject {
    /// Receive and process the latest data.
    /// Always throw an exception
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_opt(_ processor: @escaping (T) -> ()) throws -> RealmRO<T, T, RawObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
    
    /// Receive and process the latest data with write permission.
    /// Always throw an exception.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_opt_with_write_permission(_ processor: @escaping (Realm, T) -> ()) throws -> RealmRW<T, T, RawObject> {
        throw NSError(domain: "call subscribe with no data", code: -1, userInfo: nil)
    }
}

