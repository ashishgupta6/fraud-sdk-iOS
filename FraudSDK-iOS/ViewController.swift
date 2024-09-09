//
//  ViewController.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 07/08/24.
//

import UIKit
import Sign3Intelligence
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let label1 = UILabel()
        label1.text = "Hello, World!"
        label1.frame = CGRect(x: 20, y: 50, width: 200, height: 20)
        view.addSubview(label1)
        
//        Utils.checkThread()
        Utils.requestPermissionForIDFA()
        Utils.requestLocationPermission()
        
       
        let sign3Intelligence = Sign3Intelligence.getInstance()
        Utils.showInfologs(tags: "TAG_SESSION_ID", value: sign3Intelligence.getSessionId())
        sign3Intelligence.getIntelligence()
        

    }
}

