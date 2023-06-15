    //
    //  DallEMessageView.swift
    //  Generative AI
    //
    //  Created by Sudhir Pawar on 13/06/23.
    //

    import SwiftUI
    import Foundation

    struct DallEMessageView: View {
        let message: Message
        @State private var animatedText: String = ""
        @State private var isAnimate: Bool = true
        @State var num = 0
        @State private var responseImage: UIImage? = nil
        
        var body: some View {
            HStack {
                if message.isSender {
                    Spacer()
                    textView(content: message.content)
                }
                
                if !message.isSender {
                    HStack{
                      
                        VStack{
                            Image("EpamConnect")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 0)
                            Spacer()
                        }
                        
                        if let image = message.responseImage {
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
    //                                .padding()
                                    .cornerRadius(10)
                                Text("Subject of the Image - \(message.subject)")
                                    .padding(10)
                                    .background(
                                        (message.isSender ? Color.green.opacity(0.5) : Color.yellow.opacity(0.5))
                                            .blur(radius: 30)
                                        
                                    )
                                
                                    .foregroundColor(.black)
                            }
                           
                        } else {
                            
                            Text("No image available")
                                .padding()
                        }
                       
                    }
                    .padding(.bottom)
                    Spacer()
                }
                
            }
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
        






    struct DallEMessageView_Previews: PreviewProvider {
        static var previews: some View {
            DallEMessageView(message: Message(content: "https://hws.dev/paul.jpg", isSender: false, responseImage: UIImage(systemName: "arrow.up")!, subject: "Subject"))
        }
    }
    }
