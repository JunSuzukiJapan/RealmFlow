//
//  Realm+Operator.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation

import RealmSwift

// MARK: - Flow
public extension Realm {
    struct Flow { }
}

// MARK: - Write
public extension Realm.Flow {
    
    /// Adds object into the Realm.
    ///
    /// - Parameter object: The object to be added to this Realm.
    /// - Returns: `WriteOnly` operation
    public static func add(_ object: Object) -> RealmWO<Void> {
        return RealmWO<Void> { realm in realm.add(object) }
    }

    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `WriteOnly` operation
    public func delete(_ object: Object) -> RealmWO<Void> {
        return RealmWO<Void> { realm in realm.delete(object) }
    }

    /// Deletes object in the Realm.
    ///
    /// - Parameter object: The object to be removed to this Realm.
    /// - Returns: `WriteOnly` operation
    public static func deleteAll() -> RealmWO<Void> {
        return RealmWO<Void> { realm in realm.deleteAll() }
    }
}

// MARK: - Read
public extension Realm.Flow {
    
    /// Returns all objects of the given type stored in the Realm.
    ///
    /// - Parameter type: The type of the objects to be returned.
    /// - Returns: `ReadOnly` operation
    public static func objects<T: Object, Raw>(_ type: T.Type) -> RealmRO<T, Results<T>, Raw> {
        return RealmRO<T, Results<T>, Raw> { realm in
            return realm.objects(type)
        }
    }
    
    /// Returns all objects for a given class name in the Realm.
    ///
    /// - Parameter typeName: The class name of the objects to be returned.
    /// - Returns: `ReadOnly` operation
    public static func dynamicObjects(_ typeName: String) -> RealmRO<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> {
        return RealmRO<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> { realm in
            return ResultsWrapper(realm.dynamicObjects(typeName))
        }
    }
    
    /// Retrieves the single instance of a given object type with the given primary key from the Realm.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Parameter key:  The primary key of the desired object.
    /// - Returns: `ReadOnly` operation
    public static func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> RealmRO<T?, T?, RawObject> {
        return RealmRO<T?, T?, RawObject> { realm in
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
}
