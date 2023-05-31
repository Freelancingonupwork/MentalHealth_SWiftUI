//
//  SignInOptionView.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import SwiftUI

struct SignInOptionView : View{
    
    //MARK: - variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    //MARK: - view
    var body : some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                imageView
                bottomTextView
                btnSignIn
            }.background(Color.white)
                .setNavigationBar(strTitle: "Sign Up", backButtonAction: {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    
    private var imageView : some View{
        VStack{
            Image("signup-done")
                .resizable()
                .frame(height: screenSize.height/2.5)
        }.padding(.bottom, 30)
    }
    
    private var bottomTextView : some View{
        VStack (spacing: 15){
            Text("Sign up was successful.")
                .setFont(color: .primaryColor, font: 18)
            
            Text("You can start using the application now.")
                .setFont(color: .regularFontColor)
        }.padding(.bottom, 40)
       
    }
    
    private var btnSignIn : some View{
        VStack {
            Button(action: {
                Router.showMain(view: LoginView())
            }, label: {
                Text("Go to Sign in")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
                
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    //MARK: - move to next
    
}
//MARK: -  preview
struct SignInOptionView̦_Preview : PreviewProvider{
    static var previews: some View{
        SignInOptionView()
    }
}
