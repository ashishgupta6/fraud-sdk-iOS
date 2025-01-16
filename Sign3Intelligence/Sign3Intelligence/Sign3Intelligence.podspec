Pod::Spec.new do |spec|
 spec.author   = 'SIGN3 TECHNOLOGIES PRIVATE LIMITED'
 spec.homepage   = 'https://sign3.ai'
 spec.name     = 'Sign3Intelligence'
 spec.version   = '0.0.1003'
 spec.summary   = 'The Sign3 SDK is an iOS fraud prevention toolkit that assesses device security and detects risks to enhance protection against fraud.'
 spec.license = { :type => 'Custom', :text => 'Copyright 2024 SIGN3 TECHNOLOGIES PRIVATE LIMITED'}
 spec.platform   = :ios, "13"
 spec.source    = { :http => 'https://firebasestorage.googleapis.com/v0/b/make-friends-7338f.appspot.com/o/test-intelligence-iOS%2F0.0.1001%2FSign3Intelligence.xcframework.zip?alt=media&token=0ad0d595-48e9-445e-b4d6-7845ad124c14' }
 spec.vendored_frameworks = 'Sign3Intelligence.xcframework'
end
