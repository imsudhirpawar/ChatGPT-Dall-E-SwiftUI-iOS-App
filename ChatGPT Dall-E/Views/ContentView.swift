        //
        //  ContentView.swift
        //  ChatGPT Dall-E
        //
        //  Created by Sudhir Pawar on 10/06/23.
        //

        import SwiftUI

    struct ContentView: View {
        var body: some View {
            VStack {
                TabView{
                    ChatGPTView()
                        .tabItem {
                            Label("ChatGPT", systemImage: "message")
                        }
                    
                    DallEView()
                        .tabItem {
                            Label("Dall-E", systemImage: "photo.on.rectangle.angled")
                        }
                 }
              }
               .padding()
        }
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    }
