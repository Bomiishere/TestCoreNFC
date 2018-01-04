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
    let nfcReader = NFCReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    @objc func scanButtonTapped() {
        nfcReader.beginSession()
    }
}

