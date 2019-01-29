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

public class Cache<Element: NSCoding>: NSObject, CacheProtocol {
  
  public let memory: MemoryCache<Element>
  public let disk: DiskCache<Element>?
  
  public init(directory: String? = nil) {
    
    self.memory = MemoryCache<Element>()
    if let directory = directory {
      self.disk = DiskCache<Element>(directory: directory)
    }else if let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
      self.disk = DiskCache<Element>(directory: directory + "/com.BLFoundation.linhey/")
    }else {
      self.disk = nil
    }
    
    super.init()
    
    #if !os(macOS) && !os(watchOS)
    #if swift(>=4.2)
    let notifications: [(Notification.Name, Selector)] = [
      (UIApplication.didReceiveMemoryWarningNotification, #selector(clearMemoryCache)),
      (UIApplication.willTerminateNotification, #selector(cleanExpiredDiskCache)),
      (UIApplication.didEnterBackgroundNotification, #selector(backgroundCleanExpiredDiskCache))
    ]
    #else
    let notifications: [(Notification.Name, Selector)] = [
    (NSNotification.Name.UIApplicationDidReceiveMemoryWarning, #selector(clearMemoryCache)),
    (NSNotification.Name.UIApplicationWillTerminate, #selector(cleanExpiredDiskCache)),
    (NSNotification.Name.UIApplicationDidEnterBackground, #selector(backgroundCleanExpiredDiskCache))
    ]
    #endif
    notifications.forEach {
      NotificationCenter.default.addObserver(self, selector: $0.1, name: $0.0, object: nil)
    }
    #endif
  }
  
  @objc func clearMemoryCache() {
    
  }
  
  @objc func cleanExpiredDiskCache() {
    
  }
  
  @objc func backgroundCleanExpiredDiskCache() {
    
  }
  
}


extension Cache {
  
  public subscript(key: String) -> Element? {
    
    get{
      if let value = memory[key] { return value }
      if let value = disk?[key] {
        memory[key] = value
        return value
      }
      return nil
    }
    
    set {
      memory[key] = newValue
      if let value = newValue {
        disk?.set(key: key, value: value, completion: nil)
      }else {
        disk?.remove(key: key, completion: nil)
      }
    }
    
  }
  
}

extension Cache {
  
  public func get(key: String, completion: @escaping ((Element?) -> Void)) {
    memory.get(key: key) { (memoryValue) in
      
      if let memoryValue = memoryValue {
        completion(memoryValue)
        return
      }
      
      disk?.get(key: key, completion: { (diskValue) in
        
        if let diskValue = diskValue {
          self.memory.set(key: key, value: diskValue, completion: nil)
          completion(diskValue)
          return
        }
        
        completion(nil)
      })
    }
    
  }
  
  public func set(key: String, value: Element, expiration: TimeInterval?, completion: (() -> Void)?) {
    memory.set(key: key, value: value, completion: completion)
    disk?.set(key: key, value: value, completion: nil)
  }
  
  public func set(key: String, value: Element, completion: (() -> Void)?) {
    self.set(key: key, value: value, expiration: nil, completion: completion)
  }
  
  public func remove(key: String, completion: (() -> Void)?) {
    disk?.remove(key: key, completion: nil)
    memory.remove(key: key, completion: completion)
  }
  
  public func removeAll(completion: (() -> Void)?) {
    disk?.removeAll(completion: nil)
    memory.removeAll(completion: completion)
  }
  
}
