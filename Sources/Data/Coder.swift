//
//  Coder.swift
//  BLFoundation
//
//  Created by linhey on 2018/6/26.
//

import Foundation

public extension NSCoder{
  
  public func decodeString(forKey key: String) -> String{
    return decodeObject(forKey: key) as? String ?? ""
  }
  
}
