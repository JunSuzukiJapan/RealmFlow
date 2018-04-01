//
//  RealmFlow.swift
//  RealmIOStudy
//
//  Created by jun suzuki on 2018/02/16.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import Foundation
import RealmSwift

public struct RealmFlow<RW : ReadWriteType, T, U, ROW: RawOrWrap> {
    internal let _run: (Realm) throws -> U
    
    /// Obtains an instance of the `RealmFlow<RW, T>` with given operation.
    ///
    /// - Parameter _run: realm operation. Actual `realm` instance is passed when call `realm.run(flow:)`.
    public init(_ _run: @escaping (Realm) throws -> U) {
        self._run = _run
    }
}

// MARK: - typealias
/// Alias of `RealmFlow<ReadOnly, T>`
public typealias RealmRead<T, U, ROW: RawOrWrap> = RealmFlow<ReadOnly, T, U, ROW>
public typealias RealmRO<T, U, ROW: RawOrWrap> = RealmFlow<ReadOnly, T, U, ROW>

/// Alias of `RealmFlow<ReadWrite, T>`
public typealias RealmReadWrite<T, U, ROW: RawOrWrap> = RealmFlow<ReadWrite, T, U, ROW>
public typealias RealmRW<T, U, ROW: RawOrWrap> = RealmFlow<ReadWrite, T, U, ROW>

/// Alias of `RealmFlow<WriteOnly, T>`
public typealias RealmWrite<T, ROW: RawOrWrap> = RealmFlow<WriteOnly, T, T, ROW>
public typealias RealmWO<T> = RealmFlow<WriteOnly, T, T, NoObject>

//
// abstract class SequenceWrapper<T>
//    CAUTION: Don't instantiate this class.
//
public class SequenceWrapper<T> : Sequence {
    public typealias Element = T
    
    public var first: T? { get { return nil} }
    public var count: Int { get { return 0 }}
    
    public func max(by: (T, T) throws -> Bool) rethrows -> T? {
        return nil
    }
    
    public func min(by: (T, T) throws -> Bool) rethrows -> T? {
        return nil
    }
    
    public func prefix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence([])
    }
    
    public func suffix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence([])
    }
    
    public func forEach(_ body: (T) throws -> Void) rethrows {
    }

    public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) throws -> Result) rethrows -> Result {
        return initialResult
    }
    
    public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, T) throws -> ()) rethrows -> Result {
        return initialResult
    }

    // Iterator
    public func makeIterator() -> SequenceWrapper<T>._Iterator {
        return _Iterator()
    }
    
    public class _Iterator : IteratorProtocol {
        public func next() -> T? {
            return nil
        }
    }
}

internal class ArrayWrapper<T> : SequenceWrapper<T> {
    let _array: [T]
    init(_ array: [T]) {
        _array = array
    }

    public override var first: T? {
        get { return _array.first }
    }
    
    public override var count: Int { get { return _array.count }}
    
    public override func max(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _array.max(by: by)
    }
    
    public override func min(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _array.min(by: by)
    }
    
    public override func prefix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _array.prefix(maxLength) )
    }
    
    public override func suffix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _array.suffix(maxLength) )
    }
    
    public override func forEach(_ body: (T) throws -> Void) rethrows {
        try  _array.forEach(body)
    }
    
    public override func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) throws -> Result) rethrows -> Result {
        return try _array.reduce(initialResult, nextPartialResult)
    }
    
    public override func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, T) throws -> ()) rethrows -> Result {
        return try _array.reduce(into: initialResult, updateAccumulatingResult)
    }

    public override func makeIterator() -> ArrayWrapper<T>._Iterator {
        return Iterator(_array)
    }
    
    public class Iterator : SequenceWrapper<T>._Iterator {
        var iter: [T]
        var index: Int
        
        init(_ seq: [T]) {
            iter = seq
            index = 0
        }
        
        public override func next() -> T? {
            var item: T? = nil
            if index < iter.count {
                item = iter[index]
                index += 1
            }
            return item
        }
    }
}

internal class ResultsWrapper<T: Object> : SequenceWrapper<T> {
    let _results: Results<T>
    init(_ results: Results<T>) {
        _results = results
    }

    public override var first: T? {
        get { return _results.first }
    }
    
    public override var count: Int { get { return _results.count }}
    
    public override func max(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _results.max(by: by)
    }
    
    public override func min(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _results.min(by: by)
    }
    
    public override func prefix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _results.prefix(maxLength) )
    }
    
    public override func suffix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _results.suffix(maxLength) )
    }
    
    public override func forEach(_ body: (T) throws -> Void) rethrows {
        try  _results.forEach(body)
    }
    
    public override func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) throws -> Result) rethrows -> Result {
        return try _results.reduce(initialResult, nextPartialResult)
    }
    
    public override func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, T) throws -> ()) rethrows -> Result {
        return try _results.reduce(into: initialResult, updateAccumulatingResult)
    }

    // Iterator
    public override func makeIterator() -> SequenceWrapper<T>._Iterator {
        return Iterator(_results)
    }
    
    public class Iterator : SequenceWrapper<T>._Iterator {
        var iter: RLMIterator<T>
        
        init(_ seq: Results<T>) {
            iter = seq.makeIterator()
        }
        
        public override func next() -> T? {
            return iter.next()
        }
    }
}

internal class LazyFilterBidirectionalCollectionWrapper<T: Object> : SequenceWrapper<T> {
    let _seq: LazyFilterCollection<Results<T>>
    init(_ seq: LazyFilterCollection<Results<T>>) {
        _seq = seq
    }

    public override var first: T? {
        get { return _seq.first }
    }
    
    public override var count: Int { get { return _seq.count }}
    
    public override func max(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _seq.max(by: by)
    }
    
    public override func min(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _seq.min(by: by)
    }

    public override func prefix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _seq.prefix(maxLength) )
    }
    
    public override func suffix(_ maxLength: Int) -> AnySequence<T> {
        return  AnySequence( _seq.suffix(maxLength) )
    }
    
    public override func forEach(_ body: (T) throws -> Void) rethrows {
        try  _seq.forEach(body)
    }
    
    public override func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) throws -> Result) rethrows -> Result {
        return try _seq.reduce(initialResult, nextPartialResult)
    }
    
    public override func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, T) throws -> ()) rethrows -> Result {
        return try _seq.reduce(into: initialResult, updateAccumulatingResult)
    }

    // Iterator
    public override func makeIterator() -> SequenceWrapper<T>._Iterator {
        return Iterator(_seq)
    }
    
    public class Iterator : SequenceWrapper<T>._Iterator {
        var iter: LazyFilterIterator<RLMIterator<T>>
        
        init(_ seq: LazyFilterCollection<Results<T>>) {
            iter = seq.makeIterator()
        }
        
        public override func next() -> T? {
            return iter.next()
        }
    }
}

internal class LazyMapCollectionWrapper<S: Object, T> : SequenceWrapper<T> {
    let _seq: LazyMapCollection<Results<S>, T>
    init(_ seq: LazyMapCollection<Results<S>, T>) {
        _seq = seq
    }
    
    public override var first: T? {
        get { return _seq.first }
    }
    
    public override var count: Int { get { return _seq.count }}
    
    public override func max(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _seq.max(by: by)
    }
    
    public override func min(by: (T, T) throws -> Bool) rethrows -> T? {
        return try _seq.min(by: by)
    }
    
    public override func prefix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _seq.prefix(maxLength) )
    }
    
    public override func suffix(_ maxLength: Int) -> AnySequence<T> {
        return AnySequence( _seq.suffix(maxLength) )
    }
    
    public override func forEach(_ body: (T) throws -> Void) rethrows {
        try  _seq.forEach(body)
    }
    
    public override func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) throws -> Result) rethrows -> Result {
        return try _seq.reduce(initialResult, nextPartialResult)
    }
    
    public override func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, T) throws -> ()) rethrows -> Result {
        return try _seq.reduce(into: initialResult, updateAccumulatingResult)
    }

    // Iterator
    public override func makeIterator() -> SequenceWrapper<T>._Iterator {
        return Iterator(_seq)
    }
    
    public class Iterator : SequenceWrapper<T>._Iterator {
        var iter: LazyMapIterator<RLMIterator<S>, T>
        
        init(_ seq: LazyMapCollection<Results<S>, T>) {
            iter = seq.makeIterator()
        }
        
        public override func next() -> T? {
            return iter.next()
        }
    }
}
