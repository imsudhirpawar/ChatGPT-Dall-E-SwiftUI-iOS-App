//
//  Message.swift
//  ChatGPT Dall-E
//
//  Created by Sudhir Pawar on 10/06/23.
//

import Foundation
struct Message: Identifiable {
    let id = UUID()
    var content: String
    let isSender: Bool
}
