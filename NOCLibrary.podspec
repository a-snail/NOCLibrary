Pod::Spec.new do |spec|
  spec.name = 'NOCLibrary'
  spec.version = '1.0.0'
  spec.summary = 'NOCLibrary is a library that provides frequently used functions in Objective-C projects.'

  spec.homepage = 'https://github.com/a-snail/NOCLibrary'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Jaeo Bok' => 'snail.bok@gmail.com' }
  spec.social_media_url = 'https://twitter.com/snail_bok'

  spec.platforms = { :ios => '9.0' }
  spec.ios.deployment_target = '9.0'
  spec.requires_arc = true

  spec.source = { :git => 'https://github.com/a-snail/NOCLibrary.git', :tag => spec.version.to_s }
  spec.source_files = 'NOCLibrary/*.{h,m}'

  spec.dependency 'NOCLog', '~> 1.0.0'
end
