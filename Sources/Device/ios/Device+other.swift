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

// MARK: - 物理空间
public extension Device {
  
  ///  磁盘空间
  static let diskSpace = DiskSpace()
  
  /// 内存空间
  static let memorySpace = MemorySpace()
  
  public struct DiskSpace {
    /// 磁盘剩余空间 byte
    public var free: Int { return attributesOfFileSystem[.systemFreeSize] as? Int ?? -1 }
    /// 磁盘空间总量 byte
    public var total: Int { return attributesOfFileSystem[.systemSize] as? Int ?? -1 }
    /// 磁盘空间使用量 byte
    public var used: Int {
      let value = total - free
      return value <= 0 ? -1 : value
    }
    
    private var attributesOfFileSystem: [FileAttributeKey: Any] {
      do {
        return try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      }catch{
        return [:]
      }
    }
  }
  
  public struct MemorySpace {
    /// 获取当前设备可用内存 byte
    public var free: Int {
      var vmStats = vm_statistics_data_t()
      var infoCount = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
      let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &vmStats) {
        let boundBuffer = $0.bindMemory(to: Int32.self)
        return host_statistics(mach_host_self(), HOST_VM_INFO, boundBuffer.baseAddress, &infoCount)
      }
      if (kernReturn != KERN_SUCCESS) { return -1 }
      return Int(vm_page_size) * Int(vmStats.free_count)
    }
    
    /// 获取当前任务所占用的内存 byte
    public var used: Int {
      var taskInfo = task_basic_info_data_t()
      var infoCount = mach_msg_type_number_t(MemoryLayout<task_basic_info_data_t>.stride / MemoryLayout<natural_t>.stride)
      let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &taskInfo) {
        let boundBuffer = $0.bindMemory(to: Int32.self)
        return task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), boundBuffer.baseAddress, &infoCount)
      }
      if (kernReturn != KERN_SUCCESS) { return -1 }
      return Int(taskInfo.resident_size)
    }
  }
  
}


public extension Device {
  
  public static let cpu = CPU()
  
  public struct CPU {
    /// cpu 核心数
   public var count: Int {
      return ProcessInfo.processInfo.activeProcessorCount
    }
    
   public var usage: Double {
      let cpus = self.usagePerProcessor
      return cpus.reduce(0.0, { return $0 + $1 })
    }
    
  public var usagePerProcessor: [Double] {
      //todo
      return []
    }
    
  }
  
}


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


public extension UIDevice {
  
  /// 获取局域网IP
 public var wlanAddress: String? {
    var address : String?
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ifptr.pointee
      let addrFamily = interface.ifa_addr.pointee.sa_family
      if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
        let name = String(cString: interface.ifa_name)
        if  name == "en0" {
          var addr = interface.ifa_addr.pointee
          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
          getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                      &hostname, socklen_t(hostname.count),
                      nil, socklen_t(0), NI_NUMERICHOST)
          address = String(cString: hostname)
        }
      }
    }
    freeifaddrs(ifaddr)
    return address
  }
  
}

#if canImport(SystemConfiguration)
import SystemConfiguration.CaptiveNetwork

public extension Device {
  
  public struct WIFI {
    public var ssid: String? = nil
    public var bssid: String? = nil
    public var ssidData: Data? = nil
    
    public init?() {
      guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else { return nil }
      interfaceNames.forEach{ (name) in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:Any] else { return }
        if let res = info[kCNNetworkInfoKeySSID as String] as? String { ssid = res }
        if let res = info[kCNNetworkInfoKeyBSSID as String]  as? String { bssid = res }
        if let res = info[kCNNetworkInfoKeySSIDData as String] as? Data { ssidData = res }
      }
    }
  }
  
}


#endif
