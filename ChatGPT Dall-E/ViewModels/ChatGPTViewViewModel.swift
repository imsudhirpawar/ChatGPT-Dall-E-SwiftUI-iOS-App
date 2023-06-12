    //
    //  ChatGPTViewViewModel.swift
    //  ChatGPT Dall-E
    //
    //  Created by Sudhir Pawar on 10/06/23.
    //

    import Foundation

    class ChatGPTViewViewModel: ObservableObject {
        @Published var message = ""
        @Published var animatedText = ""
        @Published var chatLog: [Message] = []
        @Published var isWaitingForResponse = false
       

        
        
        @Published var headers = [
            "content-type": "application/json",
            "X-RapidAPI-Key": "a57cfb6e53msha7d93f2697beb61p158252jsncbcf2648195a",
            "X-RapidAPI-Host": "chatgpt53.p.rapidapi.com"
        ]
        
        func sendInitialMessage() {
            if chatLog.isEmpty {
                let greetingMessage = Message(content: "Hello Epamer, how can I assist you?", isSender: false)
                chatLog.append(greetingMessage)
            }
        }
        
        func animateText(text: String) {
            
            let characters = Array(text)
            for (index, character) in characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.04) {
                    self.animatedText.append(character)
                }
            }
        }
        
        func sendMessage() {
            
            isWaitingForResponse = true
            
            if !message.isEmpty {
                let senderMessage = Message(content: message, isSender: true)
                chatLog.append(senderMessage)
                
                let parameters = [
                    "messages": [
                        [
                            "role": "user",
                            "content": message
                        ]
                    ],
                    "temperature": 1
                ] as [String : Any]
                
                self.message = ""
                
                let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                
                guard let url = URL(string: "https://chatgpt53.p.rapidapi.com/") else {
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData
                
               
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "Unknown error")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse)
                    }
                    
                    if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = decodedResponse["choices"] as? [[String: Any]],
                       let msg = choices.first?["message"] as? [String: Any],
                       let response = msg["content"] as? String {
                        DispatchQueue.main.async {
                           
                            let recieveMessage = Message(content: response, isSender: false)
                            self.chatLog.append(recieveMessage)
                            
                        }
                    }
                    
                }.resume()

            }
            
            isWaitingForResponse = false
        }
        
       
    }
