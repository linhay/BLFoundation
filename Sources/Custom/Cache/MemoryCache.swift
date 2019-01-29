//
//  BLFoundation
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

public class MemoryCache<Element: NSCoding>: CacheProtocol {

  private let storage = NSCache<NSString, CacheBox<Element>>()
  private let lock = NSLock()

  public init(countLimit: Int? = nil) {
    storage.countLimit = countLimit ?? 0
  }
  

}

extension MemoryCache {
  
  // MARK: - Synchronous
  
  public subscript(key: String) -> Element? {
    get {
      return (storage.object(forKey: key as NSString))?.value
    }
    
    set(newValue) {
      lock.lock(); defer { lock.unlock() }
      if let newValue = newValue {
        let box = CacheBox(key: key, value: newValue)
        storage.setObject(box, forKey: key as NSString)
      } else {
        storage.removeObject(forKey: key as NSString)
      }
    }
  }
  
}

extension MemoryCache {
  
  public func set(key: String, value: Element, completion: (() -> Void)?) {
    self.set(key: key, value: value, expiration: nil, completion: completion)
  }
  
  public func set(key: String, value: Element, expiration: TimeInterval?, completion: (() -> Void)?) {
    lock.lock(); defer { lock.unlock() }
    let box = CacheBox(key: key, value: value, expiration: expiration ?? 0)
    storage.setObject(box, forKey: key as NSString)
    completion?()
  }
  
  public func get(key: String, completion: ((Element?) -> Void)) {
    let value = storage.object(forKey: key as NSString)?.value
    completion(value)
  }
  
  public func remove(key: String, completion: (() -> Void)? = nil) {
    self[key] = nil
    completion?()
  }
  
  public func removeAll(completion: (() -> Void)? = nil) {
    lock.lock(); defer { lock.unlock() }
    storage.removeAllObjects()
    completion?()
  }
  
}
