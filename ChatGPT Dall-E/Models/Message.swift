//
//  Message.swift
//  ChatGPT Dall-E
//
//  Created by Sudhir Pawar on 10/06/23.
//

import Foundation
import SwiftUI

struct Message: Identifiable {
    
    let id = UUID()
    var content: String
    let isSender: Bool
    var responseImage: UIImage? = nil
    var subject: String
    
    init(content: String, isSender: Bool) {
        self.content = content
        self.isSender = isSender
        self.responseImage = nil
        self.subject = ""
    }
    init(content:String, isSender: Bool, responseImage: UIImage, subject: String )
    {
        self.content = content
        self.isSender = isSender
        self.responseImage = responseImage
        self.subject = subject
    }
    
    
}


