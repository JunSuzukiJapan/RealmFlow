//
//  Realm+Run.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

public extension Realm {
    
    /// Run realm operation.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    @discardableResult
    public func run<T, U, ROW>(flow: RealmRO<T, U, ROW>) throws -> U {
        return try flow._run(self)
    }
    
    /// Run realm operation.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    @discardableResult
    public func run<T>(flow: RealmWO<T>) throws -> T {
        return try writeAndReturn { try flow._run(self) }
    }
    
    /// Run realm operation.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    @discardableResult
    public func run<T, U, ROW>(flow: RealmRW<T, U, ROW>) throws -> U {
        return try writeAndReturn { try flow._run(self) }
    }
    
    /// Run realm operation.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    /*
    @discardableResult
    public func run<T>(flow: AnyRealmIO<T>) throws -> T {
        if flow.isReadWrite {
            return try writeAndReturn { try flow._run(self) }
        } else {
            return try flow._run(self)
        }
    }
    */
}

public extension Realm {
    
    /// Run realm operation with default realm instance.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    @discardableResult
    public static func run<T, U, ROW>(flow: RealmRO<T, U, ROW>) throws -> U {
        return try flow._run(Realm())
    }
    
    /// Run realm operation with default realm instance.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    @discardableResult
    public static func run<T, U, ROW>(flow: RealmRW<T, U, ROW>) throws -> U {
        let realm = try Realm()
        return try realm.writeAndReturn { try flow._run(realm) }
    }
    
    /// Run realm operation with default realm instance.
    ///
    /// - Parameter flow: realm operation.
    /// - Returns: realm operation result.
    /// - Throws: `Realm.Error` or error thrown by user.
    /*
    @discardableResult
    public static func run<T>(flow: AnyRealmIO<T>) throws -> T {
        if flow.isReadWrite {
            let realm = try Realm()
            return try realm.writeAndReturn { try flow._run(realm) }
        } else {
            return try flow._run(Realm())
        }
    }
    */
}
