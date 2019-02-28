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
import SQLite3




public class DiskCache<Element: NSCoding>: CacheProtocol {
  
  public let directory: String
  private let fileManager = FileManager.default
  private let queue = DispatchQueue(label: "com.BLFoundation.linhey.cache.disk-cache", attributes: .concurrent)
  
  public init?(directory: String) {
    var isDirectory: ObjCBool = false
    // Ensure the directory exists
    if fileManager.fileExists(atPath: directory, isDirectory: &isDirectory) && isDirectory.boolValue {
      self.directory = directory
      return
    }
    
    self.directory = directory
    try? fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
  }
}

extension DiskCache {
  
  public subscript(key: String) -> Element? {
    get {
      return NSKeyedUnarchiver.unarchiveObject(withFile: self.path(with: key)) as? Element
    }
    set {
      let path = self.path(with: key)
      if fileManager.fileExists(atPath: path) { try? fileManager.removeItem(atPath: path) }
      if let value = newValue { NSKeyedArchiver.archiveRootObject(value, toFile: path) }
    }
  }
  
}

extension DiskCache {
  
  public func get(key: String, completion: @escaping ((Element?) -> Void)) {
    coordinate {
      let value = NSKeyedUnarchiver.unarchiveObject(withFile: self.path(with: key)) as? Element
      completion(value)
    }
  }
  
  public func set(key: String, value: Element, expiration: TimeInterval?, completion: (() -> Void)?) {
    let path = self.path(with: key)
    let fileManager = self.fileManager
    
    coordinate(barrier: true) {
      if fileManager.fileExists(atPath: path) { try? fileManager.removeItem(atPath: path) }
      NSKeyedArchiver.archiveRootObject(value, toFile: path)
      completion?()
    }
  }
  
  public func set(key: String, value: Element, completion: (() -> Void)?) {
    self.set(key: key, value: value, expiration: nil, completion: completion)
  }
  
  public func remove(key: String, completion: (() -> Void)?) {
    let path = self.path(with: key)
    let fileManager = self.fileManager
    
    coordinate {
      if fileManager.fileExists(atPath: path) { try? fileManager.removeItem(atPath: path) }
      completion?()
    }
  }
  
  
  public func removeAll(completion: (() -> Void)?) {
    let fileManager = self.fileManager
    let directory = self.directory
    
    coordinate {
      guard let paths = try? fileManager.contentsOfDirectory(atPath: directory) else { return }
      paths.forEach({ try? fileManager.removeItem(atPath: $0) })
      completion?()
    }
    
  }
  
  
}


// MARK: - Private
extension DiskCache {
  
  private func coordinate(barrier: Bool = false, block: @escaping () -> Void) {
    if barrier {
      queue.async(flags: .barrier, execute: block)
      return
    }
    queue.async(execute: block)
  }
  
  private func path(with key: String) -> String {
    return (directory as NSString).appendingPathComponent(key)
  }
  
}
