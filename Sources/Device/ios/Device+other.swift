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

#if canImport(AudioToolbox)
import AudioToolbox
public extension Device {
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter params: level  (number)  0 ~ 3 表示振动等级
  public func taptic(level: Int) {
    if #available(iOS 10.0, *),
      isSupportTaptic,
      let style = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: level) {
      
      let tapticEngine = UIImpactFeedbackGenerator(style: style)
      tapticEngine.prepare()
      tapticEngine.impactOccurred()
      
    }else{
      switch level {
      case 3:
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      case 2:
        // 连续三次短震
        AudioServicesPlaySystemSound(1521)
      case 1:
        // 普通短震，3D Touch 中 Pop 震动反馈
        AudioServicesPlaySystemSound(1520)
      default:
        // 普通短震，3D Touch 中 Peek 震动反馈
        AudioServicesPlaySystemSound(1519)
      }
    }
    
  }
}
#endif


#if canImport(AVFoundation)
import AVFoundation

public extension Device {

  /// 手电筒
  var torchOn: Bool {
    set {
      guard let device = AVCaptureDevice.default(for: .video) else { return }
      do{
        try device.lockForConfiguration()
        device.torchMode = newValue ? .on : .off
        device.unlockForConfiguration()
      }catch {
        print(error)
      }
    }get{
      guard let device = AVCaptureDevice.default(for: .video) else { return false }
      return device.torchMode == .on
    }
  }
  
}
#endif


public extension Device {
  
  /// 是否支持 Taptic Engine 功能
  public var isSupportTaptic: Bool {
    guard let version = Device.versionCode.split(separator: ",").first?.filter ({ (item) -> Bool in
      return !("a"..."z").contains(item)
    }), let num = Int(version) else { return false }
    return num > 8
  }
  
  /// 是否越狱
  public var isJailbroken: Bool {
    if Device.type == .simulator { return false }
    let paths = ["/Applications/Cydia.app",
                 "/private/var/lib/apt/",
                 "/private/var/lib/cydia",
                 "/private/var/stash"]
    
    if paths.first(where: { return FileManager.default.fileExists(atPath: $0) }) != nil { return true }
    
    if let bash = fopen("/bin/bash", "r") {
      fclose(bash)
      return true
    }
    
    if let uuid = CFUUIDCreate(nil),
      let string = CFUUIDCreateString(nil, uuid) {
      let path = "/private/" + (string as String)
      do{
        try "test".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        try FileManager.default.removeItem(atPath: path)
        return true
      }catch{
        
      }
    }
    return false
  }
  
}

