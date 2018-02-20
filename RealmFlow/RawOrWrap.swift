//
//  RawOrWrap.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

public class RawOrWrap { }

// MARK: - RawResults
/// `RawResults` is used as `RawOrWrap` type parameter of `RealmFlow<..., RawOrWrap>`
/// It represents that results type is raw Realm.Results.
public class RawResults: RawOrWrap {}

// MARK: - Wrap
/// `Wrap` is used as `RawOrWrap` type parameter of `RealmFlow<..., RawOrWrap>`
/// It represents that results type is wrapped SequenceWrapper.
public class Wrap : RawOrWrap { }

// MARK: - RawObject
/// `RawObject` is used as `RawOrWrap` type parameter of `RealmFlow<RO, T, U, RawOrWrap>`
/// It represents that results type is wrapped T.
public class RawObject : RawOrWrap { }

