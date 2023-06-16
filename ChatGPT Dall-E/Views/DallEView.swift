//
//  DallEView.swift
//  ChatGPT Dall-E
//
//  Created by Sudhir Pawar on 10/06/23.
//
/**
 I'm looking to capture {subject} in photography. please provide one prompt where you describe a scene or subject, including details and a natural speaking sentence, so I can prompt the DALL·E model to create corresponding image?
 */

import SwiftUI

struct DallEView: View {
    
    @StateObject var viewModel2 = PromptMakerViewViewModel()
    
 @StateObject var viewModel = ChatGPTViewViewModel()
    @State private var showEpamAssistView = true
    @State private var showingPopover = false
    @State private var text = ""
    @State private var subject = ""
    @State private var num = 0

   
   
    var body: some View {
        
        
        NavigationView {
            VStack{
                ZStack {
                    if showEpamAssistView{
                        AssistantView
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                     num = 1
                                }
                            }
                    } else {
                        ChatView
                    }
                }
                
                
                InputView
            }
        }
    }
    
    
    
    @ViewBuilder
    
    var AssistantView: some View{
        var text: String {
            num == 0 ? "Welcome to Epam Text to Image generation tool. Write a subject you are thinking of and see the magic..." : ""
        }
        
        
        VStack {
//            Spacer()
            
            Image("EpamConnect")
                .resizable()
                .frame(width: 150, height: 150)
                .scaleEffect(showEpamAssistView ? 0.5 : 1.0)
                .animation(.easeInOut) // Add animation modifier to the image
                .padding(.top, 90)
            
                Text(viewModel.animatedText)
                    .font(.title)
                    .bold()
                    .fontDesign(.rounded)
                    .foregroundColor(.indigo)
                    
                    .onAppear {
                        viewModel.animateText(text: text)
                        
                    }
                    .background(Color.orange.blur(radius: 70))
                    .padding()
            
            
            Spacer()
        }
    }
    
    
    var ChatView: some View{
        ScrollView {
            VStack(spacing: 35) {
                ForEach(viewModel2.chat.chatLog, id: \.id) { message in
                    DallEMessageView(message: message)
                }
            }
        }
    }
    
    var InputView: some View{
        HStack {
            TextField("Subject", text: $viewModel2.message)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        .frame(minHeight: 10)
                )

                
            Button(action:{
                viewModel2.findPrompt()
                showingPopover = true
                showEpamAssistView = false
            } ) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.indigo)
                    .opacity(viewModel2.message.isEmpty ? 0.5 : 1.0)
               
            }
//            .popover(isPresented: $showingPopover, content: {
//                PromptMakerView(closePopover: {
//                    showingPopover = false
//                }, prompt: viewModel2.message)
//
//            })
            .disabled(viewModel2.isWaitingForResponse || viewModel2.message.isEmpty)
        }
        .padding()
    }
}



struct DallEView_Previews: PreviewProvider {
    static var previews: some View {
        DallEView()
    }
}

/**
 Button("Show Menu") {
     showingPopover = true
 }
 .popover(isPresented: $showingPopover) {
     Text("Your content here")
         .font(.headline)
         .padding()
 }
 */
