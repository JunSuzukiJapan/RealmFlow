# RealmFlow

  RealmFlow makes Realm operation more easy.
  - Define Realm operation as `RealmFlow`.
  - Write operations following the previous operation, using method chain.
  - Run Realm operation with `realm.run(flow:)`.

RealmFlow call ```realm.beginTransaction()``` automatically, if needed.
So you don't need to think about transaction

example:

```swift
import RealmSwift
import RealmFlow

class Dog : Object {
    @objc dynamic var name: String = ""
}

class Cat : Object {
    @objc dynamic var name: String = ""
}

// ...

func do_operations() {
  // define data
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

  // write operations (not run yet)
  let flow = Realm.Flow
      .add(pochi)  // add pochi
      .add(tama)
      .add(hachi)
      .objects(Dog.self)  // query type Dog
      .subscribe { results in  // process query results
          print("first subscribe")
          for dog in results {
              print("dog.name: \(dog.name)")
          }
      }
      .objects(Cat.self)  // query type Cat
      .add(taro) // add taro
      .subscribe { results in  // process query type Cat results
          print("second subscribe")
          for cat in results {
              print("cat.name: \(cat.name)")
          }
      }
      .delete(pochi) // delete pochi
      .add(jiro)
      .objects(Dog.self)  // query type Dog again
      .subscribe { results in
          print("third subscribe")
          for dog in results {
              print("dog.name: \(dog.name)")
          }
      }

  // run operations
  let realm = try! Realm()
  let _ = try? realm.run(flow: flow)
}
```

# Install

## Carthage

```Cartfile
github "JunSuzukiJapan/RealmFlow"
```

## CocoaPods

```Podfile
pod 'RealmFlow', '~> 0.1'
```

# CRUD Example codes

## Create

```swift: Create New Object
    let hachi = Dog()
    hachi.name = "Hachi"
    
    let flow = Realm.Flow.add(hachi)
    
    let realm = try! Realm()
    let _ = try? realm.run(flow: flow)
```

## Read

```swift: Query
    let flow = Realm.Flow.objects(Dog.self)
        .subscribe { results in
            let name = results.first?.name ?? "No dog"
            print("dog name: \(name)")
        }

    let realm = try! Realm()
    let _ = try? realm.run(flow: flow)
```

## Update

```swift: Update
    let flow = Realm.Flow.objects(Dog.self)
        .subscribe_with_write_permission { (realm, results) in
            results.first?.name = "Pochi"
        }

    let realm = try! Realm()
    let _ = try? realm.run(flow: flow)
```

## Delete

```swift: Delete
    let flow = Realm.Flow.objects(Dog.self)
        .subscribe_with_write_permission { (realm, results) in
            if let dog = results.first {
                realm.delete(dog)
            }
        }
    
    let realm = try! Realm()
    let _ = try? realm.run(flow: flow)
```


# Credits

RealmFlow was inspired by [RealmIO](https://github.com/ukitaka/RealmIO).