//
//  ChatLogManager.swift
//  ChatGPT Dall-E
//
//  Created by Sudhir Pawar on 14/06/23.
//

import Foundation
class ChatLogManager: ObservableObject {
    @Published var chatLog: [Message] = []
}
