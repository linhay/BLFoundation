import XCTest
import BLFoundation

class Tests: XCTestCase {
  
  enum BusKey: String,EventBusKey {
    case user
    case address
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
  }
}
