//
//  DallEViewViewModel.swift
//  ChatGPT Dall-E
//
//  Created by Sudhir Pawar on 12/06/23.
//

import Foundation

class DallEViewViewModel: ObservableObject {
    @Published var message = ""
    @Published var chatLog: [Message] = []
    @Published var isWaitingForResponse = false
    
    @Published var headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": Constants.apiKey,
        "X-RapidAPI-Host": Constants.hostDallE
    ]
    
    func sendMessage(){
        guard !isWaitingForResponse else {
            return
        }
        isWaitingForResponse = true
        
        if message.isEmpty { return }
        
        let senderMessage = Message(content: message, isSender: true)
        chatLog.append(senderMessage)
        
        let parameters = [
            "prompt": message,
            "n": 1,
            "size": "1024x1024"
        ] as [String: Any]
        self.message = ""
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: Constants.baseUrlDallE) else { //your base URL
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
            
            if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: []),
               let responseDict = decodedResponse as? [String: Any],
               let dataArray = responseDict["data"] as? [[String: Any]],
               let msg = dataArray.first,
               let response = msg["url"] as? String{
                print(response)
                DispatchQueue.main.async {
                    let responseMessage = Message(content: response, isSender: false)
                    self.chatLog.append(responseMessage)
                    self.message = ""
                    self.isWaitingForResponse = false
                }
            }
            
            
        }.resume()
        
        
        isWaitingForResponse = false
        
    }
}
    /*
    private func callAPI(withPrompt prompt: String){
        let parameters = [
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ] as [String: Any]
        
        self.message = ""
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize request parameters")
            return
        }
        
        guard let url = URL(string: Constants.baseUrlDallE) else {
            print("Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("API request error:", error)
                return
            }
            
            guard let data = data else {
                print("Invalid API response data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("API response:", httpResponse.statusCode)
            }
            
            // Handle the response data
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseDict = json as? [String: Any],
                let dataArray = responseDict["data"] as? [[String: Any]] {
                
                for item in dataArray {
                    if let imageURL = item["url"] as? String {
                        print("Image URL:", imageURL)
                        DispatchQueue.main.async {
                            let responseMessage = Message(content: imageURL, isSender: false)
                            self.chatLog.append(responseMessage)
                            self.message = ""
                            self.isWaitingForResponse = false
                        }
                    }
                }
            }
        }

        task.resume()
        
    }
}
  */




/**
 
 
 let parameters = [
     "prompt": message,
     "n": 2,
     "size": "1024x1024"
 ] as [String : Any]
 
 self.message = ""
 
 let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
 
 guard let url = URL(string: Constants.baseUrlDallE) else { //baseURL
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
     
     if let decodedResponse  = try?
         JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
        let response = decodedResponse["url"] as? String {
         DispatchQueue.main.async {
             let recieveMessage = Message(content: response, isSender: false)
             self.chatLog.append(recieveMessage)
         }
     }
 }.resume()
 */
