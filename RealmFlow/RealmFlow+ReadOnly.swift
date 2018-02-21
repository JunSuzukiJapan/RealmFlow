//
//  RealmFlow+ReadOnly.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

//
//  RealmFlow
//    where RW = ReadOnly
//
public extension RealmFlow where RW: ReadOnly {
    /// Returns all objects of the given type stored in the Realm.
    ///
    /// - Parameter type: The type of the objects to be returned.
    /// - Returns: `ReadWrite` operation
    public func objects<T: Object>(_ type: T.Type) -> RealmRO<T, Results<T>, RawResults> {
        return RealmRO<T, Results<T>, RawResults> { realm in
            let _ = try! self._run(realm)
            return realm.objects(type)
        }
    }
    
    /// Returns all objects for a given class name in the Realm.
    ///
    /// - Parameter typeName: The class name of the objects to be returned.
    /// - Returns: `ReadOnly` operation
    public func dynamicObjects(_ typeName: String) -> RealmRO<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> {
        return RealmRO<DynamicObject, SequenceWrapper<DynamicObject>, Wrap> { realm in
            let _ = try! self._run(realm)
            return ResultsWrapper(realm.dynamicObjects(typeName))
        }
    }
    
    /// Retrieves the single instance of a given object type with the given primary key from the Realm.
    ///
    /// - Parameter type: The type of the object to be returned.
    /// - Parameter key:  The primary key of the desired object.
    /// - Returns: `ReadOnly` operation
    public func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> RealmRO<T?, T?, RawObject> {
        return RealmRO<T?, T?, RawObject> { realm in
            let _ = try! self._run(realm)
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
}

//
//  RealmFlow
//    where ReadOrWrapper = Raw, U = Results<T>
//
public extension RealmFlow where RW: ReadOnly, T: Object, U: Results<T>, ROW: RawResults {

    /// Receive and process the latest data.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe(_ processor: @escaping (Results<T>) -> ()) -> RealmRO<T, Results<T>, RawResults> {
        return RealmRO<T, Results<T>, RawResults>{ realm in
            let results = try! self._run(realm)
            processor(results)
            return results
        }
    }
    
    /// Receive and process the latest data with write permission.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_with_write_permission(_ processor: @escaping (Realm, Results<T>) -> ()) -> RealmRW<T, Results<T>, RawResults> {
        return RealmRW<T, Results<T>, RawResults>{ realm in
            let results = try! self._run(realm)
            processor(realm, results)
            return results
        }
    }

    /// Receive and sort the latest data.
    ///
    /// - Parameter by: The method for comparing two objects.
    public func sorted(_ by: @escaping (T, T) throws -> Bool) -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        return RealmRO<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).sorted(by: by)
            return ArrayWrapper(results)
        }
    }
    
    /* SequenceWrapper版との互換性のために削除 */
    /*
     public func sorted(_ byKeyPath: String) -> RealmRO<T, Results<T>, Raw> {
     return RealmRO<T, Results<T>, Raw> { realm in
     let results = try! self._run(realm).sorted(byKeyPath: byKeyPath)
     return results
     }
     }
     
     public func sorted(_ byKeyPath: String, ascending: Bool) -> RealmRO<T, Results<T>, Raw> {
     return RealmRO<T, Results<T>, Raw> { realm in
     let results = try! self._run(realm).sorted(byKeyPath: byKeyPath, ascending: ascending)
     return results
     }
     }
     */
    
    /// Receive and filter the latest data.
    ///
    /// - Parameter predicate: The method for filtering object.
    public func filter(_ predicate: @escaping (T) -> Bool) -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        return RealmRO<T, SequenceWrapper<T>, Wrap> { realm in
            let results = try! self._run(realm).filter { predicate($0) }
            return LazyFilterBidirectionalCollectionWrapper(results)
        }
    }
    
    /* SequenceWrapper版との互換性のために削除 */
    /*
     public func map<V>(transform: @escaping (T) -> V) -> RealmRO<T, SequenceWrapper<V>, Wrap> {
     return RealmRO<T, SequenceWrapper<V>, Wrap> { realm in
     let results: LazyMapCollection<Results<T>, V> = try! self._run(realm).map(transform)
     return LazyMapCollectionWrapper(results)
     }
     }
     */
}

//
//  RealmFlow
//    where ReadOrWrapper = Wrapper
//
public extension RealmFlow where RW: ReadOnly, T: Object, U: SequenceWrapper<T>, ROW: Wrap {

    /// Receive and process the latest data.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe(_ processor: @escaping (SequenceWrapper<T>) -> ()) -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        return RealmRO<T, SequenceWrapper<T>, Wrap>{ realm in
            let results = try! self._run(realm)
            processor(results)
            return results
        }
    }
    
    /// Receive and process the latest data with write permission.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_with_write_permission(_ processor: @escaping (Realm, SequenceWrapper<T>) -> ()) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap>{ realm in
            let results = try! self._run(realm)
            processor(realm, results)
            return results
        }
    }
    
    /// Receive and sort the latest data.
    ///
    /// - Parameter by: The method for comparing two objects.
    public func sorted(_ by: @escaping (T, T) throws -> Bool) -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        return RealmRO<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).sorted(by: by)
            return ArrayWrapper(results)
        }
    }
    
    /// Receive and filter the latest data.
    ///
    /// - Parameter predicate: The method for filtering object.
    public func filter(_ predicate: @escaping (T) -> Bool) -> RealmRO<T, SequenceWrapper<T>, Wrap> {
        return RealmRO<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).filter { predicate($0) }
            return ArrayWrapper(results)
        }
    }
    
    /* VがRealm.Objectとは限らないのでストリームに流すのは問題？ */
    /*
     public func map<V>(transform: @escaping (T) -> V) -> RealmRO<T, SequenceWrapper<V>, Wrap> {
     return RealmRO<T, SequenceWrapper<V>, Wrap> { realm in
     let results: [V] = try! self._run(realm).map(transform)
     return ArrayWrapper(results)
     }
     }
     */
}

//
//  RealmFlow
//    where ReadOrWrapper = RawObject
//
public extension RealmFlow where RW: ReadOnly, ROW: RawObject {

    /// Receive and process the latest data.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_opt(_ processor: @escaping (T) -> ()) -> RealmRO<T, T, RawObject> {
        return RealmRO<T, T, RawObject>{ realm in
            let result: T = try! self._run(realm) as! T
            processor(result)
            return result
        }
    }
    
    /// Receive and process the latest data with write permission.
    ///
    /// - Parameter processor: The method for processing result.
    public func subscribe_opt_with_write_permission(_ processor: @escaping (Realm, T) -> ()) -> RealmRW<T, T, RawObject> {
        return RealmRW<T, T, RawObject>{ realm in
            let result: T = try! self._run(realm) as! T
            processor(realm, result)
            return result
        }
    }
}


