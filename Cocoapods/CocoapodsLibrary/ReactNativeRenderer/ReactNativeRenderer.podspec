Pod::Spec.new do |spec|
  spec.name         = 'ReactNativeRenderer'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/cipolleschi/react-native'
  spec.authors      = { 'Riccardo Cipolleschi' => 'cipolleschi@meta.com' }
  spec.summary      = 'A test to prepare prebuilds using cocoapods'
  spec.source       = { :git => 'https://github.com/cipolleschi/react-native.git', :tag => 'v0.0.1' }
  spec.platform     = :ios, '15.1'
  spec.source_files = '**/*.{h,m,cpp}'
end
