//
//  ViewController.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 07/08/24.
//

import UIKit
import Sign3Intelligence

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let label1 = UILabel()
        label1.text = "Hello, World!"
        label1.frame = CGRect(x: 20, y: 50, width: 200, height: 20)
        view.addSubview(label1)
//        Utils.checkThread()
        var sign3Intelligence = Sign3Intelligence.getInstance()
        sign3Intelligence.getIntelligence()
    }
}

