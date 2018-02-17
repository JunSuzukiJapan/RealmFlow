//
//  ReadWrite.swift
//  RealmFlowStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation

public class ReadWriteType { }

// MARK: - ReadOnly
/// `ReadOnly` is used as `RW` type parameter of `RealmFlow<RW, T>`
/// It represents that realm operation is readonly.
public class ReadOnly: ReadWriteType { }

public typealias Read = ReadOnly

// MARK: - WriteOnly
/// `WriteOnly` is used as `RW` type parameter of `RealmFlow<RW, T>`
/// It represents that realm operation don't have query methods.
public class WriteOnly: ReadWriteType { }

public typealias Write = WriteOnly

// MARK: - ReadWrite
/// `ReadWrite` is used as `RW` type parameter of `RealmFlow<RW, T>`
/// It represents that realm operation needs to call `realm.write`.
public class ReadWrite : ReadWriteType { }
