//
//  Realm+Util.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import RealmSwift

internal extension Realm {
    func writeAndReturn<T>(block: () throws -> T) throws -> T {
        beginWrite()
        let t: T
        do {
            t = try block()
        } catch let error {
            if isInWriteTransaction { cancelWrite() }
            throw error
        }
        if isInWriteTransaction { try commitWrite() }
        return t
    }
}
