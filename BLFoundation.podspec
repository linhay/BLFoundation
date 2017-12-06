Pod::Spec.new do |s|
  s.name             = 'BLFoundation'
  s.version          = '0.2.0'
  s.summary          = 'Foundation extersion'

  s.description      = <<-DESC
Foundation extersion without nothing
                       DESC

  s.homepage         = 'https://github.com/bigL055/BLFoundation'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author           = { '158179948@qq.com' => '158179948@qq.com' }
  s.source           = { :git => 'https://github.com/bigL055/BLFoundation.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = ['Sources/*/**','Sources/**']
  s.public_header_files = 'Sources/BLFoundation.h'
end
