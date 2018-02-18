Pod::Spec.new do |s|
  s.name             = 'RealmFlow'
  s.version          = '0.1.3'
  s.summary          = 'RealmFlow makes Realm operation more easy.'

  s.description      = <<-DESC
  RealmFlow makes Realm operation more easy.
  - Define Realm operation as `RealmFlow`.
  - Run Realm operation with `realm.run(flow:)`.
  - Write operations Following the previous operations, without being disturbed thinking.

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
      .subscribe { results in  // process query type Cat
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


                       DESC

  s.homepage         = 'https://github.com/JunSuzukiJapan/RealmFlow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JunSuzukiJapan' => 'jun.suzuki.japan@gmail.com' }
  s.source           = { :git => 'https://github.com/JunSuzukiJapan/RealmFlow.git', :tag => s.version.to_s }

  s.swift_version = '4.0'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'RealmFlow/**/*'
  s.frameworks  = "Foundation"
  s.dependency 'RealmSwift',  '~> 3.1'
end
