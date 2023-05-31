//
//  ForgotPasswordView.swift
//  TutumNetUI
//
//  Created by Apple on 27/02/23.
//

import SwiftUI


struct ForgotPasswordView : View{
    //MARK: -  variable
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var strEmail : String = ""
    @State private var navigateToView = false
    @State private var isLoading = false
    
    
    //MARK: - view
    var body : some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    ForgotPasswordLabel
                    txtEmail.padding(.bottom,20)
                    btnForgotPassword.padding(.bottom, 30)
                }.padding(.horizontal,20)
            }
            NavigationLink(isActive: $navigateToView, destination: { ResetPasswordView() }, label: { EmptyView() })
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: "", isBackButton: true, isLogo: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private var ForgotPasswordLabel : some View{
        VStack{
            Text("Forgot Password")
                .font(MainFont.bold.with(size: 30))
                .foregroundColor(Color.primaryColor)
        }.padding(.vertical, 30)
    }
    private var txtEmail : some View{
        HStack {
            Image("email").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField("Email", text: $strEmail).keyboardType(.emailAddress).setLightFont(color: .black).padding(.trailing,10)
        }
        .padding()
        .dropShadowAndCorner()
    }
    private var btnForgotPassword : some View{
        VStack {
            Button(action: {
                if !Utils.isValidEmail(strEmail ){
                    Utils.showToast(strMessage: "please enter valid email")
                }
                else{
                    forgetPassword()
                }
            }, label: {
                Text("Forgot Password")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
                
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
    //MARK: -  api call
    func forgetPassword(){
        isLoading.toggle()
        let param : [String:Any] = ["email" : strEmail]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .forgotPassword) , param: param, completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(ForgetPasswordModel.self, from: responseData)
                        if model.status{
                            Utils.showToast(strMessage: model.message ?? "")
                            navigateToView.toggle()
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
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
