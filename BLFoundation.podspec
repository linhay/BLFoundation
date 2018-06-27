Pod::Spec.new do |s|
s.name             = 'BLFoundation'
s.version          = '0.5.5'
s.summary          = 'A set of useful categories for Foundation.'

s.homepage = 'https://github.com/linhay/BLFoundation'
s.license  = { :type => 'MIT', :file => 'LICENSE' }
s.author   = { 'linhay' => 'is.linhay@outlook.com' }
s.source   = { :git => 'https://github.com/linhay/BLFoundation.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ['Sources/*/**','Sources/**']

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
