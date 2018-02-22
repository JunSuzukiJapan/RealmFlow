//
//  RealmFlowTests.swift
//  RealmFlowTests
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import XCTest
import RealmSwift
@testable import RealmFlow

class Dog : Object {
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }

    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

class Cat : Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}

class RealmFlowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        
        let flow = Realm.Flow.deleteAll()
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdd(){
        let pochi = Dog()
        pochi.name = "Pochi"

        let flow = Realm.Flow.add(pochi)
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }
    
    func testObjects(){
        let pochi = Dog()
        pochi.name = "Pochi"
        
        let flow = Realm.Flow.add(pochi)
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)

        let query = Realm.Flow.objects(Dog.self)
            .subscribe { results in
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.name, "Pochi")
            }
        let _ = try? realm.run(flow: query)
    }
    
    func testFileterAndSorted(){
        let pochi = Dog()
        pochi.name = "Pochi"
        let hachi = Dog()
        hachi.name = "Hachi"
        let taro = Dog()
        taro.name = "Taro"
        let jiro = Dog()
        jiro.name = "Jiro"
        
        let flow = Realm.Flow
            .add(pochi)
            .add(hachi)
            .add(taro)
            .add(jiro)
            .objects(Dog.self)
            .filter {$0.name.contains("ro")}
            .sorted {$0.name < $1.name}
            .subscribe { results in
                XCTAssertEqual(results.count, 2)
                let iter = results.makeIterator()
                XCTAssertEqual(iter.next()?.name, "Jiro")
                XCTAssertEqual(iter.next()?.name, "Taro")
            }

        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }
    
    func testPrimaryKey(){
        let pochi = Dog()
        pochi.name = "Pochi"
        let hachi = Dog()
        hachi.name = "Hachi"
        
        let flow = Realm.Flow
            .add(pochi)
            .add(hachi)
            .object(ofType: Dog.self, forPrimaryKey: "Pochi")
            .subscribe_opt { result in
                XCTAssertNotNil(result as Any)
                XCTAssertEqual(result?.name, "Pochi")
            }
            .object(ofType: Dog.self, forPrimaryKey: "Hachi")
            .subscribe_opt { result in
                XCTAssertNotNil(result as Any)
                if let dog = result {
                    XCTAssertEqual(dog.name, "Hachi")
                }
            }

        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }

    func testAddAndQuery(){
        let pochi = Dog()
        pochi.name = "Pochi"
        let tama = Cat()
        tama.name = "Tama"
        let hachi = Dog()
        hachi.name = "Hachi"
        
        var flow = Realm.Flow
            .add(tama)
            .add(pochi)
        let flow2 = Realm.Flow.add(hachi)
        flow = flow.combine(flow2)

        let realm = try! Realm()
        try? realm.run(flow: flow)
        
        let test = Realm.Flow.objects(Dog.self)
        let results = try! realm.run(flow: test)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].name, "Pochi")
        XCTAssertEqual(results[1].name, "Hachi")
        
        let test2 = Realm.Flow.objects(Cat.self)
        let results2 = try! realm.run(flow: test2)
        XCTAssertEqual(results2.count, 1)
        XCTAssertEqual(results2.first?.name, "Tama")
    }
    
    func testUpdate(){
        let tama = Cat()
        tama.id = "cat1"
        tama.name = "Tama"
        
        let addFlow = Realm.Flow
            .add(tama)

        let updateFlow = Realm.Flow
            .object(ofType: Cat.self, forPrimaryKey: "cat1")
            .subscribe_opt_with_write_permission { realm, result in
                XCTAssertNotNil(result as Any)
                XCTAssertEqual(result?.name, "Tama")
                result!.name = "Buchi"
            }

        let checkFlow = Realm.Flow
            .objects(Cat.self)
            .subscribe { results in
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.name, "Buchi")
            }

        let realm = try! Realm()
        let _ = try! realm.run(flow: addFlow)
        let _ = try! realm.run(flow: updateFlow)
        let _ = try! realm.run(flow: checkFlow)
    }

    /*
    func testCannotUpdate(){
        let tama = Cat()
        tama.id = "cat1"
        tama.name = "Tama"
        
        let addFlow = Realm.Flow
            .add(tama)
        
        let updateFlow = Realm.Flow
            .object(ofType: Cat.self, forPrimaryKey: "cat1")
            .subscribe_opt { result in
                result!.name = "Buchi"
            }
        
        let realm = try! Realm()
        let _ = try! realm.run(flow: addFlow)
        //XCTAssertThrowsError( try realm.run(flow: updateFlow) ) // why do not catch error?
    }
    */
    
    // ビルドできればOK
    func testCombine(){
        let pochi = Dog()
        pochi.name = "Pochi"
        let tama = Cat()
        tama.id = "cat1"
        tama.name = "Tama"

        let readOnlyFlow = Realm.Flow.objects(Dog.self)
        let writeOnlyFlow = Realm.Flow.add(pochi)
        let readWriteFlow = Realm.Flow.add(pochi).objects(Dog.self)

        let combineROandRO = readOnlyFlow.combine(readOnlyFlow)
        let combineROandWO = readOnlyFlow.combine(writeOnlyFlow)
        let combineROandRW = readOnlyFlow.combine(readWriteFlow)
        
        let combineWOandRO = writeOnlyFlow.combine(readOnlyFlow)
        let combineWOandWO = writeOnlyFlow.combine(writeOnlyFlow)
        let combineWOandRW = writeOnlyFlow.combine(readWriteFlow)
        
        let combineRWandRO = readWriteFlow.combine(readOnlyFlow)
        let combineRWandWO = readWriteFlow.combine(writeOnlyFlow)
        let combineRWandRW = readWriteFlow.combine(readWriteFlow)

        let RO2 = Realm.Flow.objects(Cat.self)
        let WO2 = Realm.Flow.add(tama)
        let RW2 = Realm.Flow.add(tama).objects(Cat.self)
        
        let _ = readOnlyFlow.combine(RO2)
        let _ = readOnlyFlow.combine(WO2)
        let _ = readOnlyFlow.combine(RW2)
        let _ = writeOnlyFlow.combine(WO2)
        let _ = writeOnlyFlow.combine(RO2)
        let _ = writeOnlyFlow.combine(RW2)
        let _ = readWriteFlow.combine(RW2)
        let _ = readWriteFlow.combine(RO2)
        let _ = readWriteFlow.combine(WO2)
        
        let _ = combineROandRO.subscribe { results in }
        let _ = try? combineROandWO.subscribe { }
        let _ = combineROandRW.subscribe { results in }

        let _ = combineWOandRO.subscribe { results in }
        let _ = try? combineWOandWO.subscribe { }
        let _ = combineWOandRW.subscribe { results in }

        let _ = combineRWandRO.subscribe { results in }
        let _ = try? combineRWandWO.subscribe { }
        let _ = combineRWandRW.subscribe { results in }
    }
    
    func testDelete(){
        let tama = Cat()
        tama.id = "cat1"
        tama.name = "Tama"
        
        let addFlow = Realm.Flow
            .add(tama)
            .object(ofType: Cat.self, forPrimaryKey: "cat1")
            .subscribe_opt { cat_opt in
                XCTAssertEqual(cat_opt?.name, "Tama")
            }

        let deleteFlow = Realm.Flow
            .object(ofType: Cat.self, forPrimaryKey: "cat1")
            .subscribe_opt_with_write_permission { realm, cat_opt in
                realm.delete(cat_opt!)
            }
        
        let checkFlow = Realm.Flow
            .object(ofType: Cat.self, forPrimaryKey: "cat1")
            .subscribe_opt { cat_opt in
                XCTAssertTrue(cat_opt == nil)
            }

        let realm = try! Realm()
        let _ = try! realm.run(flow: addFlow)
        let _ = try! realm.run(flow: deleteFlow)
        let _ = try! realm.run(flow: checkFlow)
    }

    func testComplexFlow() {
        let pochi = Dog()
        pochi.name = "Pochi"
        let tama = Cat()
        tama.name = "Tama"
        let hachi = Dog()
        hachi.name = "Hachi"
        let taro = Dog()
        taro.name = "Taro"
        let jiro = Dog()
        jiro.name = "Jiro"
        
        let flow = Realm.Flow.deleteAll()
            .add(pochi)
            .add(tama)
            .add(hachi)
            .objects(Dog.self)
            .subscribe { results in
                XCTAssertEqual(results.count, 2)
                let sorted = results.sorted(by: {dog1, dog2 in dog1.name < dog2.name})
                XCTAssertEqual(sorted[0].name, "Hachi")
                XCTAssertEqual(sorted[1].name, "Pochi")
            }
            .objects(Cat.self)
            .add(taro)
            .subscribe { results in
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.name, "Tama")
            }
            .delete(pochi)
            .add(jiro)
            .objects(Dog.self)
            .subscribe { results in
                XCTAssertEqual(results.count, 3)
                let sorted = results.sorted(by: {dog1, dog2 in dog1.name < dog2.name})
                XCTAssertEqual(sorted[0].name, "Hachi")
                XCTAssertEqual(sorted[1].name, "Jiro")
                XCTAssertEqual(sorted[2].name, "Taro")
            }
        
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }

}
