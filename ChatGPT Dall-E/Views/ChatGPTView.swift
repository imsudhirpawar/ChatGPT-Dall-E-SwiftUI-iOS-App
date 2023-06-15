    //
    //  ChatGPTView.swift
    //  ChatGPT Dall-E
    //
    //  Created by Sudhir Pawar on 10/06/23.
    //

    import SwiftUI

    struct ChatGPTView: View {
        @StateObject var viewModel = ChatGPTViewViewModel()
        @State private var showEpamAssistView = true
        @State private var num = 0
        @State var showAnimation = true
        


        var body: some View {
            NavigationView {
               VStack {
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
                num == 0 ? "EPAM Assistant" : ""
            }
            
            
            VStack {
                Spacer()
               
                Image("EpamConnect")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaleEffect(showEpamAssistView ? 0.5 : 1.0)
                    .animation(.easeInOut) // Add animation modifier to the image
                    .padding(.top, 0)
                
                    Text(viewModel.animatedText)
                        .font(.title)
                        .bold()
                        .fontDesign(.rounded)
                        .foregroundColor(.indigo)
                        
                        .onAppear {
                            viewModel.animateText(text: text)
                            
                        }
                        .background(Color.orange.blur(radius: 70))
                
                
                Spacer()
            }
        }
        
        var ChatView: some View {
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(viewModel.chatLog, id: \.id) { message in
                        MessageView(message: message)
                    }
                }
            }
        }

        var InputView: some View{
            HStack {
                TextField("Message", text: $viewModel.message)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            .frame(minHeight: 10)
                    )

                    
                Button(action:{
                    viewModel.sendMessage()
                    showEpamAssistView = false
                    
                } ) {
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.indigo)
                        .opacity(viewModel.message.isEmpty ? 0.5 : 1.0)
                   
                }
                .disabled(viewModel.isWaitingForResponse || viewModel.message.isEmpty)
            }
            .padding()
        }
        
    }


       struct ChatGPTView_Previews: PreviewProvider {
           static var previews: some View {
               ChatGPTView()
           }
       }
