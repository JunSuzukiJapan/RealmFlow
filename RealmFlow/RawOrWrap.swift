//
//  RawOrWrap.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

public class RawOrWrap { }

// MARK: - Raw
/// `Raw` is used as `RawOrWrap` type parameter of `RealmFlow<..., RawOrWrap>`
/// It represents that results type is raw Realm.Results.
public class Raw: RawOrWrap {}

// MARK: - Wrap
/// `Wrap` is used as `RawOrWrap` type parameter of `RealmFlow<..., RawOrWrap>`
/// It represents that results type is wrapped Realm.Results.
public class Wrap : RawOrWrap { }

