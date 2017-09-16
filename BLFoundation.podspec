Pod::Spec.new do |s|
s.name             = 'BLFoundation'
s.version          = '0.1.1'
s.summary          = '基于 Foundation 的一些扩展'


s.homepage         = 'https://github.com/bigL055/BLFoundation'
s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
s.author           = { 'lin' => 'linhan.bigl055@outlook.com' }
s.source = { :git => 'https://github.com/bigL055/BLFoundation.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["Sources/*/**","Sources/*/*/**","Sources/**"]

s.public_header_files = ["Sources/BLFoundation.h"]
s.frameworks = ['Foundation']
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end

