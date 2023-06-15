    //
    //  PromptMakerViewViewModel.swift
    //  Generative AI
    //
    //  Created by Sudhir Pawar on 13/06/23.
    //

    import Foundation
    import SwiftUI
    class PromptMakerViewViewModel: ObservableObject {
        @Published var responsePrompt = ""
        @Published var message = ""
        @Published var msg = ""
        @ObservedObject var chat = ChatLogManager()
        @Published var sub = ""
        @Published var isWaitingForResponse = false
//        @Published var img: Message = Message(content: "", isSender: false, responseImage: UIImage(systemName: "paperPlane")!)
      
       
        @Published var headers = [
            "content-type": "application/json",
            "X-RapidAPI-Key": Constants.apiKey ,    // your api key
            "X-RapidAPI-Host": Constants.hostChatGPT    // your base url
        ]
     
        
        
        
        func findPrompt() {
            
            
             
            
            guard !isWaitingForResponse else {
                    return
                }
            
            isWaitingForResponse = true
            
            let contentString = "I'm looking to capture " + message + " in photography. please provide one prompt where you describe a scene or subject, including details and a natural speaking sentence in 20 words only, so I can prompt the DALL·E model to create corresponding image?"
            
            sub = self.message
            self.message = ""
            
                let parameters = [
                    "messages": [
                        [
                            "role": "user",
                            "content": contentString
                        ]
                    ],
                    "temperature": 1
                ] as [String : Any]
                
                
                
                let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                
                guard let url = URL(string: Constants.baseUrlChatGPT) else { //your base URL
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
                            print(response)
                            self.responsePrompt = response
                            let recieveMessage = Message(content: response, isSender: true)
                            
                            
                            self.chat.chatLog.append(recieveMessage)

                            self.sendMessage()
                            
                            
                            print("message Sent to DallEViewModel")

//                            print(self.chat.chatLog)

                        }
                        
                    }
                    
                }.resume()

            
            
            
        }
        
        func sendMessage( ){
            print("came to sendMessage")
//            guard !isWaitingForResponse else {
//                print("returned")
//                    return
//                }
           
            
            isWaitingForResponse = true
            
//            if !responsePrompt.isEmpty { return }
            
            guard let url = URL(string: Constants.baseUrlSD) else {
                print("Invalid URL")
                return
            }
            
            let data: [String: Any] = ["inputs": responsePrompt]
            
            self.responsePrompt = ""
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(Constants.authToken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let image = UIImage(data: data) {
                   
                    DispatchQueue.main.async {
                        
                        
                        let recImage = Message(content: "", isSender: false, responseImage: image, subject: self.sub)
                        self.message = ""
                        self.chat.chatLog.append(recImage)
                        print("Appended reciever Message ")
                        print(self.chat.chatLog)
                        self.isWaitingForResponse = false
                        
                    }
                    
                }
                
            }.resume()
             
            
        }
       
    }
