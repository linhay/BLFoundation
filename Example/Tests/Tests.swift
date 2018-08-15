import XCTest
import BLFoundation

class Tests: XCTestCase {
  
  enum BusKey: String,EventBusKey {
    case user
    case address
  }
  
  func testEventBus() {
    var eventBus = EventBus<BusKey,String>()
    let observer: NSObject = NSObject()
    eventBus.subscribe(observer: observer, key: .user) { (item) in
      XCTAssert(item == "user")
    }
    eventBus.push(key: .user, value: "user")
  }
  
  
}
