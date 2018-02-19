//
//  RealmFlowTests.swift
//  RealmFlowTests
//
//  Created by jun suzuki on 2018/02/17.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import XCTest
@testable import RealmFlow
import RealmSwift

class Dog : Object {
    public var name: String = ""
}

class Cat : Object {
    public var name: String = ""
}

class RealmFlowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccess(){
        XCTAssertTrue(true)
    }
    
    func testAdd(){
        let poti = Dog()
        poti.name = "Poti"
        let tama = Cat()
        tama.name = "Tama"
        let hachi = Dog()
        hachi.name = "Hachi"
        
        var flow = Realm.Flow.add(tama)
            .add(poti)
        let flow2 = Realm.Flow.add(hachi)
        flow = flow.combine(flow2)
        
        let realm = try! Realm()
        try? realm.run(flow: flow)
    }
    
    func testQuery(){
        let flow = Realm.Flow.objects(Dog.self)
            .subscribe { results in
                print("results = \(results)")
                //let a = results.filter(NSPredicate(format: "name != %@", argumentArray: ["Poti"]))
                for dog in results {
                    print("1 name: \(dog.name)")
                }
            }
            .filter({ $0.name != "Poti" })
            .subscribe { results in
                for dog in results {
                    print("2 name: \(dog.name)")
                }
        }
        
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }
    
    func testManyFlow() {
        let pochi = Dog()
        pochi.name = "Poti"
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
                print("first subscribe")
                for dog in results {
                    print("dog.name: \(dog.name)")
                }
            }
            .objects(Cat.self)
            .add(taro)
            .subscribe { results in
                print("second subscribe")
                for cat in results {
                    print("cat.name: \(cat.name)")
                }
            }
            .delete(pochi)
            .add(jiro)
            .objects(Dog.self)
            .subscribe { results in
                print("third subscribe")
                for dog in results {
                    print("dog.name: \(dog.name)")
                }
            }
        
        let realm = try! Realm()
        let _ = try? realm.run(flow: flow)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
