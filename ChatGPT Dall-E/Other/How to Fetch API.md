#  <#Title#>

import SwiftUI

struct ContentView: View {
    @State private var responseData = ""
    
    var body: some View {
        VStack {
            Text(responseData)
                .padding()
            
            Button("Fetch API") {
                fetchData()
            }
            .padding()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.example.com/endpoint") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseData = responseString
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
