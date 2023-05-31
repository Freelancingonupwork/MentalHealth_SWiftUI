//
//  loginView.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//


import SwiftUI
import GoogleSignIn
import AuthenticationServices

enum loginType {
    case signin
    case signup
}

struct LoginView : View{
    //MARK: -  variable
    @State private var strEmail : String = ""
    @State private var strPassword : String = ""
    @State private var showPassword : Bool = false
    @State private var showToast = false
    @State private var navigateToView = false
    @State private var loginParam = [String:Any]()
    @State private var strFname = ""
    @State private var strLname = ""
    @State private var isLoading = false
    let string = "By signing up, you agree to XXXX's Terms & Conditions and Privacy Policy"
    let appleSignInCoordinator = AppleSignInCoordinator(type: .signin)
    private let appleLogin = NotificationCenter.default.publisher(for: NSNotification.Name.appleLogin )

    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    SignInLabel
                    txtEmail.padding(.bottom,20)
                    txtPassword.padding(.bottom,10)
                    btnForgotPassword.padding(.bottom,10)
                    btnSignIn.padding(.bottom, 30)
                    deviderView.padding(.bottom, 30)
                    socialLoginView.padding(.bottom,30)
                    bottomView.padding(.bottom,30)
                    signUpView.padding(.bottom,30)
                }.padding(.horizontal,20)
            }
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
            
            NavigationLink(isActive: $navigateToView, destination: { EditProfileView(strFname: strFname, strLname: strLname, isSocailLogin: true) }, label: { EmptyView() })
        }.onReceive(appleLogin, perform: { output in
            strFname = "\(output.userInfo?["fname"] ?? "")"
            strLname = "\(output.userInfo?["lname"] ?? "")"
            strEmail = "\(output.userInfo?["email"] ?? "")"
            strPassword = "\(output.userInfo?["password"] ?? "")"
            loginParam =  ["email" :  strEmail,
               "password" : strPassword,
               "socialloginkey" : strPassword,
               "loginwith" : "APPLE",
               "devicetokon" : strDeviceToken,]
            login()
        })
        .setNavigationBar(strTitle: "", isBackButton: false, isLogo: true)
            .background(Color.white)
           
    }
    
    private var SignInLabel : some View{
        VStack{
            Text("Sign in")
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
    
    private var btnForgotPassword : some View{
        NavigationLink(destination: ForgotPasswordView(), label: {
            HStack {
                Spacer()
                Text("Forgot Password ?")
                    .setFont(color: .regularFontColor)
                    .gradientForeground()
            }
        })

    }
    private var btnSignIn : some View{
        VStack {
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil,  from: nil,  for: nil)
                if !Utils.isValidEmail(strEmail ){
                    Utils.showToast(strMessage: "please enter valid email")
                }
                else if strPassword.isEmpty {
                    Utils.showToast(strMessage: "please enter password")
                }
                else{
                   loginParam =  ["email" : strEmail,
                      "password" : strPassword,
                      "devicetokon" : strDeviceToken,]
                    login()
//                        Router.showMain(view: HomeView())
                }
            }, label: {
                Text("Sign In")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
                
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
    private var deviderView : some View{
        VStack {
            Divider().overlay(
                Text("OR")
                    .setFont(color: .regularFontColor)
                    .padding(.all, 20)
                    .background(Color.white)
            )
        }
    }
    
    private var socialLoginView : some View{
        HStack {
            VStack {
                Button(action: {
                    googleLogin()
                }, label: {
                    Image("google").resizable().frame(width: 25, height: 25).padding(.all)
                })
            } .frame(maxWidth : .infinity)
            .dropShadowAndCorner()
            
            Spacer(minLength: 30.0)
            
            VStack {
                Button(action: {
                    performSignInWithApple()
                }, label: {
                    Image("apple").resizable().frame(width: 25, height: 25).padding(.all)
                })
            } .frame(maxWidth : .infinity)
            .dropShadowAndCorner()
        }
    }
    
    private var bottomView : some View{
        VStack {
            (
            Text(" By proceeding you also agree to the ")
                .font(MainFont.medium.with(size: 16))
                .foregroundColor(Color.regularFontColor) +

            Text("Terms of Service ")
                .font(MainFont.medium.with(size: 15))
                .foregroundColor(Color.lightBlueColor)
//                .onTapGesture {
//                    print("tearm of service clicked")
//                }
            +

            Text("and ")
                .font(MainFont.medium.with(size: 16))
                .foregroundColor(Color.regularFontColor) +

            Text("Privacy Policy")
                .font(MainFont.medium.with(size: 15))
                .foregroundColor(Color.lightBlueColor)
//                .onTapGesture {
//                    print("Privacy Policy clicked")
//                }
            )

            .multilineTextAlignment(.center)

        }

    }
    
    private var signUpView : some View{
        
        NavigationLink(destination: RegisterView()){
            VStack{
                (
                Text("Don't have an account ? ")
                    .font(MainFont.medium.with(size: 16))
                    .foregroundColor(Color.regularFontColor) +//+
                                                        
                Text("Sign Up")
                    .font(MainFont.medium.with(size: 15))
                    .foregroundColor(Color.lightBlueColor)
                )   .multilineTextAlignment(.center)
            }
        }
               
        
    }
   
    
    //MARK: -  google login
    func googleLogin(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
         let signInConfig = GIDConfiguration.init(clientID: "1072109851920-7gqc3eqg5l8lu7lchc6eqp2rdji5hgl4.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
         GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, completion: { user, error in
                 if let error = error {
                     Utils.showToast(strMessage: "error: \(error.localizedDescription)")
                 }
     
             guard let myUser = user?.user else { return }
             strFname = myUser.profile?.givenName ?? "" // fname
             strLname =  myUser.profile?.familyName ?? "" // lname
             loginParam =  ["email" :   myUser.profile?.email ?? "",
                "password" : myUser.userID ?? "",
                "socialloginkey" :myUser.userID ?? "",
                "loginwith" : "GOOGLE",
                "devicetokon" : strDeviceToken,]
             login()
         })
    }
    
    //MARK: -  other method
    func moveToNext(){
        navigateToView.toggle()
    }
    
    func performSignInWithApple() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = appleSignInCoordinator
            authorizationController.performRequests()
        }
    
    //MARK: - Api Calls
    func login(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .login) , param: loginParam, completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(LoginModel.self, from: responseData)
                        if model.status{
                            Utils.storeDataInLocal(key: .accessToken, model.token ?? "")
                            if let bool = model.sendNotification{
                                Utils.storeDataInLocal(key: .isNotificationOn, bool == "YES" ? true : false)
                            }
                            (model.isfirstlogin ?? false) ? moveToNext() : Router.showMain(view: HomeView())
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

//MARK: - preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate {
    
    let type : loginType
    init(type : loginType) {
        self.type = type
        super.init()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            print("User Identifier: \(userIdentifier)")
            _ = appleIDCredential.user
            let info = ["fname" : appleIDCredential.fullName?.givenName ?? "" ,
                        "lname" : appleIDCredential.fullName?.familyName ?? "" ,
                        "email" : appleIDCredential.email ?? "",
                        "password" : appleIDCredential.user]
            NotificationCenter.default.post(name: type == .signin ? .appleLogin : .appleSignup,  object: nil, userInfo: info)
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error.localizedDescription)")
    }
}
