import XCTest
import BLFoundation

class Tests: XCTestCase {
  
  enum BusKey: String,EventBusKey {
    case user
    case address
  }
  
  
  func testIntFamily() {
    // .string
    XCTAssert(64.string == "64")
    XCTAssert(Int8(64).string == "64")
    XCTAssert(Int16(64).string == "64")
    XCTAssert(Int32(64).string == "64")
    XCTAssert(Int64(64).string == "64")
    
    XCTAssert(UInt8(64).string == "64")
    XCTAssert(UInt16(64).string == "64")
    XCTAssert(UInt32(64).string == "64")
    XCTAssert(UInt64(64).string == "64")
    
    print(-1.abs)
    // abs
    XCTAssert(0.abs == 0)
    XCTAssert((-1).abs == 1)
    XCTAssert(1.abs == 1)
  }
  
  
  func testDynamic() {
    let name = Dynamic("linhey")
    name.bind { (item) in
      print("bind: ",item)
    }
    
    for index in 0...10 {
      DispatchQueue.global().async {
        name.value = index.string
        print("name: ",name.value)
      }
    }
    
  }
  
  
  
  //  事件总线
  func testEventBus() {
    var eventBus = EventBus<BusKey,String>()
    let observer: NSObject = NSObject()
    eventBus.subscribe(observer: observer, key: .user) { (item) in
      XCTAssert(item == "user")
    }
    eventBus.push(key: .user, value: "user")
  }
  
  //  机型
  func testDevice() {
    XCTAssert(Device.type != .unknown)
//    XCTAssert(Device.version != .unknown)
    print(Device.type)
    print(Device.version)
  }
  
  
  func testString() {
    let str = "1234567890"
    XCTAssert(str[5] == .some("6"))
    XCTAssert(str[20] == nil)
    XCTAssert(str[-20] == nil)
    XCTAssert(str[0] == .some("1"))
    XCTAssert(str[9] == .some("0"))

    XCTAssert(str[0...5] == "123456")
    XCTAssert(str[0..<5] == "12345")
    XCTAssert(str[..<5] == "12345")
    XCTAssert(str[5...] == "67890")
    XCTAssert(str[...5] == "123456")
    
    XCTAssert(str[-10...(-5)] == "")
    XCTAssert(str[-10...100] == str)
    XCTAssert(str[3...6] == "4567")

    XCTAssert(str[-10..<100] == str)
    XCTAssert(str[3..<6] == "456")
    
    XCTAssert(str.substring(before: "") == "")
    XCTAssert(str.substring(before: "456") == "123")
    XCTAssert(str.substring(before: "1") == "")
    XCTAssert("11111111".substring(before: "11") == "")

    XCTAssert(str.substring(after: "") == "")
    XCTAssert(str.substring(after: "456") == "7890")
    XCTAssert(str.substring(after: "0") == "")
    XCTAssert("11111111".substring(after: "11") == "111111")
  }
}
