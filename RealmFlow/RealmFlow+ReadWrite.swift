//
//  RealmFlow+ReadWrite.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

public extension RealmFlow where RW: ReadWrite {
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
    /// - Returns: `ReadOnly` operation
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
    /// - Returns: `ReadOnly` operation
    public func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> RealmRW<T?, T?, RawObject> {
        return RealmRW<T?, T?, RawObject> { realm in
            let _ = try! self._run(realm)
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
}

//
//  RealmFlow
//    where ReadOrWrapper = RawResults
//
public extension RealmFlow where RW: ReadWrite, T: Object, U: Results<T>, ROW: RawResults {
    public func subscribe(onNext: @escaping (Results<T>) -> ()) -> RealmRW<T, Results<T>, RawResults> {
        return RealmRW<T, Results<T>, RawResults>{ realm in
            let results = try! self._run(realm)
            onNext(results)
            return results
        }
    }
    
    public func subscribe_with_write_permission(onNext: @escaping (Realm, Results<T>) -> ()) -> RealmRW<T, Results<T>, RawResults> {
        return RealmRW<T, Results<T>, RawResults>{ realm in
            let results = try! self._run(realm)
            onNext(realm, results)
            return results
        }
    }
    
    public func sorted(_ by: @escaping (T, T) throws -> Bool) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).sorted(by: by)
            return ArrayWrapper(results)
        }
    }
    
    public func filter(_ predicate: @escaping (T) -> Bool) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap> { realm in
            let results = try! self._run(realm).filter { predicate($0) }
            return LazyFilterBidirectionalCollectionWrapper(results)
        }
    }
}

//
//  RealmFlow
//    where ReadOrWrapper = Wrapper
//
public extension RealmFlow where RW: ReadWrite, T: Object, U: SequenceWrapper<T>, ROW: Wrap {
    public func subscribe(onNext: @escaping (SequenceWrapper<T>) -> ()) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap>{ realm in
            let results = try! self._run(realm)
            onNext(results)
            return results
        }
    }
    
    public func subscribe_with_write_permission(onNext: @escaping (Realm, SequenceWrapper<T>) -> ()) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap>{ realm in
            let results = try! self._run(realm)
            onNext(realm, results)
            return results
        }
    }
    
    public func sorted(_ by: @escaping (T, T) throws -> Bool) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).sorted(by: by)
            return ArrayWrapper(results)
        }
    }
    
    public func filter(_ predicate: @escaping (T) -> Bool) -> RealmRW<T, SequenceWrapper<T>, Wrap> {
        return RealmRW<T, SequenceWrapper<T>, Wrap> { realm in
            let results: [T] = try! self._run(realm).filter { predicate($0) }
            return ArrayWrapper(results)
        }
    }
}


//
//  RealmFlow
//    where ReadOrWrapper = RawObject, U = T?
//
public extension RealmFlow where RW: ReadWrite, ROW: RawObject {
    // メモ： subscribe() だと、RawResultsなのかRawObjectなのか、
    // コンパイラがうまく判断してくれないようなので、
    // 諦めて別名のメソッドにした。
    public func subscribe_opt(onNext: @escaping (T?) -> ()) -> RealmRW<T?, T?, RawObject> {
        return RealmRW<T?, T?, RawObject>{ realm in
            let result: T? = try! self._run(realm) as! T
            onNext(result)
            return result
        }
    }
    
    public func subscribe_opt_with_write_permission(onNext: @escaping (Realm, T?) -> ()) -> RealmRW<T?, T?, RawObject> {
        return RealmRW<T?, T?, RawObject>{ realm in
            let result: T? = try! self._run(realm) as! T
            onNext(realm, result)
            return result
        }
    }
}
