//
//  ResetPasswordView.swift
//  TutumNetUI
//
//  Created by Apple on 27/02/23.
//

import SwiftUI

struct ResetPasswordView : View{
    
    //MARK: - variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var strCode : String = ""
    @State private var strPassword : String = ""
    @State private var showPassword : Bool = false
    @State private var isLoading = false
    
    //MARK: -  view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    ResetPasswordLabel
                    txtPassword.padding(.bottom,20)
                    txtCode.padding(.bottom,20)
                    btnResetPassword.padding(.bottom, 30)
                }.padding(.horizontal,20)
                
            }
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: "", isBackButton: true, isLogo: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private var ResetPasswordLabel : some View{
        VStack{
            Text("Reset Password")
                .font(MainFont.bold.with(size: 30))
                .foregroundColor(Color.primaryColor)
        }.padding(.vertical, 30)
    }
    private var txtPassword : some View{
        HStack {
            Image("lock").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            if !showPassword{
                SecureField("Password", text: $strPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
            }
            else{
                TextField("Password", text: $strPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
            }
             
            Button(action: {
                        showPassword.toggle()
                    }, label: {
                        Image(systemName: !showPassword ? "eye.fill" : "eye.slash.fill").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30).gradientForeground()
            })
            
        }
        .padding()
        .dropShadowAndCorner()
    }
    private var txtCode : some View{
        HStack {
            Image(systemName: "key").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30).gradientForeground()//.foregroundColor(.lightBlueColor)
            TextField("Code", text: $strCode).keyboardType(.emailAddress).setLightFont(color: .black).padding(.trailing,10)
        }
        .padding()
        .dropShadowAndCorner()
    }
    private var btnResetPassword : some View{
        VStack {
            Button(action: {
                if strCode.isEmpty{
                    Utils.showToast(strMessage: "please enter valid code")
                }
                else if strPassword.isEmpty{
                    Utils.showToast(strMessage: "please enter valid password")
                }
                else{
                    
                }
            }, label: {
                Text("Reset Password")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
                
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
    //MARK: - api call
    func resetPassword(){
        isLoading.toggle()
        let param : [String:Any] = ["code" : strCode , "password" : strPassword]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .resetPassword) , param: param, completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(LoginModel.self, from: responseData)
                        if model.status{
                            Utils.showToast(strMessage: model.message ?? "")
                            Router.showMain(view: LoginView())
                        }
                        else{
                            Utils.showToast(strMessage: model.message ?? "")
                        }
                }
                catch{
                    print(error.localizedDescription)
                    Utils.showToast(strMessage: messageKey.somethingWrong)
                }
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}

//MARK: -  preview
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
