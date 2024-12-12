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
    static var shared: ViewController?
    
    let sign3Intelligence = Sign3Intelligence.getInstance()
    let listener = Sign3()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the shared reference
        ViewController.shared = self
        let titleLabel = UILabel()
        titleLabel.text = "Sign3 SDK"
        titleLabel.textColor = .white  // Set the text color
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        //        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Change the background color of the navigation bar
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor.white  // Set the background color to blue
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white // Set the title text color to white
            ]
            navigationBar.isTranslucent = false  // Disable translucency for a solid color
        }
        
        let button1 = UIBarButtonItem(title: "Get Intelligence", style: .plain, target: self, action: #selector(button1Tapped))
        let button2 = UIBarButtonItem(title: "Update Options", style: .plain, target: self, action: #selector(button2Tapped))
        
        // Add buttons to the navigation bar
        navigationItem.rightBarButtonItems = [button1, button2]
        
        view.backgroundColor = .white
        
        // Add label and textView to the view
        view.addSubview(label1)
        view.addSubview(textView)
        
        // Set Auto Layout constraints
        label1.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            label1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // TextView constraints
            textView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        Utils.requestPermissionForIDFA()
        Utils.requestLocationPermission()
        
        label1.text = "Session Id: \(sign3Intelligence.getSessionId())"
        sign3Intelligence.getIntelligence(listener: listener)
    }
    
    class Sign3: IntelligenceResponseListener{
        
        func onSuccess(response: IntelligenceResponse) {
            if let jsonString = response.toJson() {
                DispatchQueue.main.async {
                    ViewController.shared?.textView.text = jsonString
                }
            }
        }
        
        func onError(error: IntelligenceError) {
            print("TAG_INTELLIGENCE_ERROR: \(error.errorMessage), \(error.requestId)")
        }
    }
    
    // Action for the first button
    @objc func button1Tapped() {
        label1.text = "Session Id: \(sign3Intelligence.getSessionId())"
        sign3Intelligence.getIntelligence(listener: listener)
    }
    
    // Action for the second button
    @objc func button2Tapped() {
        Sign3Intelligence.getInstance().updateOptions(updateOption:  UpdateOption.Builder()
            .setPhoneNumber("1234567890")
            .setUserId("12345")
            .setPhoneInputType(PhoneInputType.GOOGLE_HINT)
            .setOtpInputType(OtpInputType.AUTO_FILLED)
            .setUserEventType(UserEventType.TRANSACTION)
            .setMerchantId("1234567890")
            .setAdditionalAttributes(
                ["SIGN_UP_TIMESTAMP": String(Date().timeIntervalSince1970 * 1000),
                 "SIGNUP_METHOD": "PASSWORD",
                 "REFERRED_BY": "UserID",
                 "PREFERRED_LANGUAGE": "English"
                ]
            ).build())
    }
}

extension IntelligenceResponse {
    func toJson() -> String? {
        var dictionary: [String: Any] = [
            "deviceId": self.deviceId,
            "requestId": self.requestId,
            "simulator": self.simulator,
            "jailbroken": self.jailbroken,
            "vpn": self.vpn,
            "geoSpoofed": self.geoSpoofed,
            "appTampering": self.appTampering,
            "hooking": self.hooking,
            "proxy": self.proxy,
            "mirroredScreen": self.mirroredScreen,
        ]
        
        // Include `gpsLocation` only if it's not nil
        if let gpsLocation = self.gpsLocation {
            dictionary["gpsLocation"] = [
                "latitude": gpsLocation.latitude,
                "longitude": gpsLocation.longitude,
                "altitude": gpsLocation.altitude
            ]
        }
        
        // Convert to JSON
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
        
        return nil
    }
}

