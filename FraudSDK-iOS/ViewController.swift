//
//  ViewController.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 07/08/24.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import Sign3Intelligence

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label1 = UILabel()
        label1.text = "Sign3 SDK Testing..."
        label1.frame = CGRect(x: 20, y: 50, width: 200, height: 20)
        label1.textColor = .black  // Set text color to black
        view.addSubview(label1)
        
        //        Utils.checkThread()
        Utils.requestPermissionForIDFA()
        Utils.requestLocationPermission()
        
        
        let simulatorChecker = SimulatorChecker()
        simulatorChecker.isSimulator()
        let sign3Intelligence = Sign3Intelligence.getInstance()
        Utils.showInfologs(tags: "TAG_SESSION_ID", value: sign3Intelligence.getSessionId())
        sign3Intelligence.getIntelligence()
        
        
//        Sign3Intelligence.getInstance().updateOptions(updateOption:  UpdateOption.Builder()
//            .setPhoneNumber("1234567890")
//            .setUserId("12345")
//            .setPhoneInputType(PhoneInputType.GOOGLE_HINT)
//            .setOtpInputType(OtpInputType.AUTO_FILLED)
//            .setUserEventType(UserEventType.TRANSACTION)
//            .setMerchantId("1234567890")
//            .setAdditionalAttributes(
//                ["SIGN_UP_TIMESTAMP": String(Date().timeIntervalSince1970 * 1000),
//                 "SIGNUP_METHOD": "PASSWORD",
//                 "REFERRED_BY": "UserID",
//                 "PREFERRED_LANGUAGE": "English"
//                ]
//            ).build())
    }
}

