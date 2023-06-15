    //
    //  PromptMakerView.swift
    //  Generative AI
    //
    //  Created by Sudhir Pawar on 13/06/23.
    //

    import SwiftUI

    struct PromptMakerView: View {
        @StateObject var viewModel = PromptMakerViewViewModel()
//            @StateObject var viewModel2 = DallEViewViewModel()
        
        
        let closePopover: () -> Void
        
        let prompt: String
        
        
        var body: some View {
            VStack{
                Spacer()
                
                if !viewModel.responsePrompt.isEmpty {
                    Text(viewModel.responsePrompt)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .opacity(0.5)
                            .blur(radius: 30)
                        )
                        .foregroundColor(.black)
                        
                }
                else{
                    Text("Making Prompt just wait for a sec...")
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .opacity(0.5)
                            .blur(radius: 30)
                        )
                        .foregroundColor(.black)

                        
                }
                
               
                ButtonView
                Spacer()
                
            }
            .onAppear {
                    viewModel.message = prompt
                
                    viewModel.findPrompt()
                
            }
        }
    


var ButtonView: some View{
    HStack(spacing: 20) {
        Button(action: {
            // Action for "Use This Prompt" button
//                viewModel2.msg = viewModel.responsePrompt
            
                viewModel.sendMessage()
            closePopover()
            print("Use This Prompt button tapped")
        }) {
            Text("Use prompt")
//                    .bold()
//                    .foregroundColor(.green)
                .padding()
                .background(
                    .bar
                )
                .cornerRadius(10)
                
        }
        
        Button(action: {
            // Action for "Use Another Subject" button
            closePopover()
            print("Use Another Subject button tapped")
        }) {
            Text("Go Back")
                .foregroundColor(.red)
                .padding()
                .background(
                    .bar
                )
                .cornerRadius(10)
        }
    }
    .padding()
}

}
    struct PromptMakerView_Previews: PreviewProvider {
        static var previews: some View {
            PromptMakerView(closePopover: {}, prompt: "Car")
            
        }
    }


