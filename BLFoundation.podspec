Pod::Spec.new do |s|
  s.name             = 'BLFoundation'
  s.version          = '0.8.0'
  s.summary          = 'A set of useful categories for Foundation.'
  
  s.homepage = 'https://github.com/linhay/BLFoundation'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { 'linhay' => 'is.linhay@outlook.com' }
  s.source   = { :git => 'https://github.com/linhay/BLFoundation.git', :tag => s.version.to_s }
  
  s.swift_version = '4.2'
  
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  
  s.public_header_files = ["Sources/BLFoundation.h"]
  s.source_files = ['Sources/*.h']

  s.subspec 'Coder' do |ss|
    ss.source_files   = 'Sources/Coder/*.swift'
  end
  
  s.subspec 'NSObject' do |ss|
    ss.source_files   = 'Sources/NSObject/*.swift'
  end
  
  s.subspec 'Device' do |ss|
    ss.source_files   = 'Sources/Device/*.swift'
    ss.ios.source_files   = 'Sources/Device/ios/*.swift'
  end
  
  s.subspec 'Thread' do |ss|
    ss.source_files = 'Sources/Thread/**'
  end
  
  s.subspec 'Custom' do |ss|
    ss.source_files = 'Sources/Custom/*/**'
  end
  
  s.subspec 'String' do |ss|
    ss.source_files = 'Sources/String/**'
  end
  
  s.subspec 'Stdlib' do |ss|
    ss.source_files = 'Sources/Stdlib/**'
  end
  
  s.subspec 'Date' do |ss|
    ss.source_files = 'Sources/Date/**'
  end
  
  s.subspec 'URL' do |ss|
    ss.source_files = 'Sources/URL/**'
  end
  
  s.subspec 'Data' do |ss|
    ss.source_files = 'Sources/Data/**'
  end
  
  s.subspec 'Tools' do |ss|
    ss.source_files = 'Sources/Tools/**'
  end
  
  
end
