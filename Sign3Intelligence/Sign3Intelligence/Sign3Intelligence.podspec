Pod::Spec.new do |spec|
  spec.name         = 'Sign3Intelligence'
  spec.version      = '0.0.1000'
  spec.summary      = 'Sign3Intelligence Summary'
  spec.description  = 'Sign3Intelligence Description'
  spec.homepage     = 'https://sign3.ai/'
  spec.license = { :type => 'Custom', :text => 'Copyright 2024 SIGN3 TECHNOLOGIES PRIVATE LIMITED'}
  spec.author      = {'Ashish Gupta' => 'ashish.gupta@sign3labs.com'}
  spec.platform     = :ios, "13"
  spec.source       = { :http => 'https://firebasestorage.googleapis.com/v0/b/make-friends-7338f.appspot.com/o/test-intelligence-iOS%2F0.0.1000%2FSign3Intelligence.xcframework.zip?alt=media&token=ab25c46e-ca3f-4ac1-ba9d-a8103b207a5e' }
  spec.vendored_frameworks = 'Sign3Intelligence.xcframework'
end
