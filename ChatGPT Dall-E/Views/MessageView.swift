    //
    //  MessageView.swift
    //  ChatGPT Dall-E
    //
    //  Created by Sudhir Pawar on 10/06/23.
    //

    import SwiftUI

    struct MessageView: View {
        let message: Message
        @State private var animatedText: String = ""
        @State private var isAnimate: Bool = true
        @State var num = 0
        
        var body: some View {
            HStack {
                if message.isSender {
                    Spacer()
                    textView(content: message.content)
                }
                
                if !message.isSender {
                    
                    if isAnimate{
                        
                        HStack{
                            VStack{
                                Image("EpamConnect")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 0)
                                Spacer()
                            }
                            
                                
                            textView(content: animatedText)
                                .onAppear {
                                    animateText()
                                    num = 1
                                }
                            Spacer()
                        }
                        Spacer()
                       
                        
                    }
                    else{
                        HStack{
                            VStack{
                                Image("EpamConnect")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 0)
                                Spacer()
                            }
                            textView(content: message.content)
                            
                        }
                        Spacer()
                        
                            
                    }
                    
                    Spacer()
                }
            }
            .padding(.bottom)
        }
        
        @ViewBuilder
        func textView(content: String) -> some View {
            Text(content)
                .padding(10)
                .background(
                    (message.isSender ? Color.green.opacity(0.5) : Color.yellow.opacity(0.5))
                        .blur(radius: 30)

                )

                .foregroundColor(.black)
                .bold()
          
        }
        
        private func animateText() {
            guard !message.content.isEmpty else {
                
                return
            }
            
            let characters = Array(message.content)
            for (index, character) in characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.04) {
                    animatedText.append(character)
                }
            }
            if num != 0 {
                animatedText = ""
                isAnimate = false
            }
            
            
            
        }
    }




    struct MessageView_Previews: PreviewProvider {
        static var previews: some View {
            MessageView(message: Message(content: "Epam Chatbot", isSender: true))
        }
    }
