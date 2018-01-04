//
//  NFCReader.swift
//  TestCoreNFC
//
//  Created by Bomi on 2017/12/29.
//  Copyright © 2017年 PrototypeC. All rights reserved.
//

import Foundation
import CoreNFC

class NFCReader: NSObject , NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            var result = ""
            for record in message.records {

                print("New Record Found:")
                
                
//                result += String.init(data: record.payload.advanced(by: 3), encoding: .utf8)! // 1
//
//                print(NSString(data: record.identifier, encoding: 0))
                
                print(String(data: record.payload, encoding: .utf8))
//                print(NSString(data: record.type, encoding: 0))
//                print(record.typeNameFormat)
            }
//            print(result)
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC NDEF Invalidated")
        print("\(error.localizedDescription)")
    }
    
    func beginSession() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.begin()
    }
}
