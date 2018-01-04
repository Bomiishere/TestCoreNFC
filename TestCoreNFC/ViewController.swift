//
//  ViewController.swift
//  TestCoreNFC
//
//  Created by Bomi on 2017/12/29.
//  Copyright © 2017年 PrototypeC. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    let nfcReader = NFCReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(updateResultTextView), name: Notification.Name(rawValue: "scanresults"), object: nil)
    }
    
    @objc func updateResultTextView(notification: Notification) {
        if let userInfo = notification.userInfo as? [String:String],
            let updatedText = userInfo["results"] {
            self.resultTextView.text = updatedText
        }
    }
    
    @objc func scanButtonTapped() {
        nfcReader.beginSession()
    }
}

