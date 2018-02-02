Pod::Spec.new do |s|
s.name             = 'BLFoundation'
s.version          = '0.4.2'
s.summary          = 'Foundation extersion'

s.description      = <<-DESC
Foundation extersion without nothing
DESC

s.homepage = 'https://github.com/bigL055/BLFoundation'
s.license  = { :type => 'Apache License 2.0', :file => 'LICENSE' }
s.author   = { 'linhey' => 'linhan.linhey@outlook.com' }
s.source   = { :git => 'https://github.com/bigL055/BLFoundation.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ['Sources/*/**','Sources/**']
s.public_header_files = 'Sources/BLFoundation.h'

s.subspec 'String' do |ss|
ss.source_files = 'Sources/String/**'
end

s.subspec 'Date' do |ss|
ss.source_files = 'Sources/Date/**'
end

s.subspec 'Number' do |ss|
ss.source_files = 'Sources/Number/**'
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
