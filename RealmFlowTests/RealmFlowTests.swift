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
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }

    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

class RealmFlowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPrimaryKey(){
        let pochi = Dog()
        pochi.name = "Pochi"
        let hachi = Dog()
        hachi.name = "Hachi"
        
        let flow = Realm.Flow.deleteAll()
            .add(pochi)
            .add(hachi)
            .object(ofType: Dog.self, forPrimaryKey: "Pochi")
            .subscribe_opt { result in
                XCTAssertNotNil(result as Any)
                if let dog = result {
                    XCTAssertEqual(dog?.name, "Pochi")
                }
            }
            .object(ofType: Dog.self, forPrimaryKey: "Hachi")
            .subscribe_opt { result in
                XCTAssertNotNil(result as Any)
                if let dog = result {
                    XCTAssertEqual(dog?.name, "Hachi")
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
        
        var flow = Realm.Flow.deleteAll()
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

    func testManyFlow() {
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
