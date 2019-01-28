Pod::Spec.new do |s|
  
  s.name             = 'BLFoundation'
  s.version          = '0.8.6'
  s.summary          = 'A set of useful categories for Foundation.'
  
  s.homepage = 'https://github.com/linhay/' + s.name
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { 'linhay' => 'is.linhay@outlook.com' }
  s.source   = { :git => 'https://github.com/linhay/BLFoundation.git', :tag => s.version.to_s }
  
  s.swift_version = '4.2'
  
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  
  s.public_header_files = ['Sources/BLFoundation.h']
  s.source_files = ['Sources/*.h']

  list = ['Coder', 'NSObject', 'String', 'Stdlib', 'Date', 'URL', 'Data']
  
  for name in list
    s.subspec name do |ss|
      ss.source_files = 'Sources/' + name + '/*.swift'
    end
  end
  
  s.subspec 'Device' do |ss|
    ss.watchos.source_files = ['Sources/Device/core/*.swift']
    ss.tvos.source_files    = ['Sources/Device/core/*.swift']
    ss.osx.source_files     = ['Sources/Device/core/*.swift']
    ss.ios.source_files     = ['Sources/Device/core/*.swift', 'Sources/Device/ios/*.swift' ]
    ss.ios.frameworks = 'SystemConfiguration'
    ss.osx.frameworks = 'SystemConfiguration'
  end
  
  s.subspec 'Custom' do |ss|
    ss.source_files = ['Sources/Custom/*/**', 'Sources/Custom/*.swift']
  end
  
end
