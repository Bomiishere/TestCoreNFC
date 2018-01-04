//
//  NFCReader.swift
//  TestCoreNFC
//
//  Created by Bomi on 2017/12/29.
//  Copyright © 2017年 PrototypeC. All rights reserved.
//

import Foundation
import CoreNFC
import VYNFCKit

class NFCReader: NSObject , NFCNDEFReaderSessionDelegate {
    
    public var results: String = ""
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        for message in messages {
            for payload in message.records {
                guard let parsedPayload = VYNFCNDEFPayloadParser.parse(payload) else {
                    continue
                }
                
                var text = ""
                var urlString = ""
                
                if let parsedPayload = parsedPayload as? VYNFCNDEFTextPayload {
                    
                    text = "[Text payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.text)
                    
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFURIPayload {
                    
                    text = "[URI payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.uriString)
                    urlString = parsedPayload.uriString
                    
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFTextXVCardPayload {
                    
                    text = "[TextXVCard payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.text)
                    
                } else if let sp = parsedPayload as? VYNFCNDEFSmartPosterPayload {
                    
                    text = "[SmartPoster payload]\n"
                    for textPayload in sp.payloadTexts {
                        if let textPayload = textPayload as? VYNFCNDEFTextPayload {
                            text = String(format: "%@%@\n", text, textPayload.text)
                        }
                    }
                    text = String(format: "%@%@", text, sp.payloadURI.uriString)
                    urlString = sp.payloadURI.uriString
                    
                } else if let wifi = parsedPayload as? VYNFCNDEFWifiSimpleConfigPayload {
                    
                    for case let credential as VYNFCNDEFWifiSimpleConfigCredential in wifi.credentials {
                        text = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                      text, credential.ssid, credential.networkKey, credential.macAddress,
                                      VYNFCNDEFWifiSimpleConfigCredential.authTypeString(credential.authType),
                                      VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(credential.encryptType)
                        )
                    }
                    if let version2 = wifi.version2 {
                        text = String(format: "%@\nVersion2: %@", text, version2.version)
                    }
                    
                } else {
                    
                    text = "Parsed but unhandled payload type"
                }
                
                NSLog("%@", text)
                results = String(format:"%@%@\n", results, text);
                DispatchQueue.main.async {
                    // display results
                    NotificationCenter.default.post(name: Notification.Name("scanresults"), object: nil, userInfo: ["results": self.results])
                    if urlString != "" {
                        
                        //Close NFC reader session and open URI after delay.
                        //Not all can be opened on iOS.
                        
                        session.invalidate()
                        if let url = URL(string: urlString) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            })
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func beginSession() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session.begin()
    }
}
