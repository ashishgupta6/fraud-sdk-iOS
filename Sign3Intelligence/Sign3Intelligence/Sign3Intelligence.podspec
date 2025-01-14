Pod::Spec.new do |spec|
  spec.name         = 'Sign3Intelligence'
  spec.version      = '0.0.1001'
  spec.summary      = 'Sign3Intelligence Summary'
  spec.description  = 'Sign3Intelligence Description'
  spec.homepage     = 'https://sign3.ai/'
  spec.license = { :type => 'Custom', :text => 'Copyright 2024 SIGN3 TECHNOLOGIES PRIVATE LIMITED'}
  spec.author      = {'Ashish Gupta' => 'ashish.gupta@sign3labs.com'}
  spec.platform     = :ios, "13"
  spec.source       = { :http => 'https://firebasestorage.googleapis.com/v0/b/make-friends-7338f.appspot.com/o/test-intelligence-iOS%2F0.0.1001%2FSign3Intelligence.xcframework.zip?alt=media&token=0ad0d595-48e9-445e-b4d6-7845ad124c14' }
  spec.vendored_frameworks = 'Sign3Intelligence.xcframework'
end
 
