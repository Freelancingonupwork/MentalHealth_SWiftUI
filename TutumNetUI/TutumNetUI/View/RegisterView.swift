//
//  RegisterView.swift
//  TutumNetUI
//
//  Created by Apple on 22/02/23.
//



import SwiftUI
import iPhoneNumberField
import GoogleSignIn
import AuthenticationServices

struct RegisterView : View{
    //MARK: -  variable
    @State private var strEmail : String = ""
    @State private var strPassword : String = ""
    @State private var strConformPassword : String = ""
    @State private var showPassword : Bool = false
    @State private var showPassword1 : Bool = false
    @State private var strPhoneNumber = ""
    @State private var navigateToView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var signUpParam = [String:Any]()
    @State private var strFname = ""
    @State private var strLname = ""
    @State private var isLoading = false
    private let appleSignup = NotificationCenter.default.publisher(for: NSNotification.Name.appleSignup )
    private let appleSignInCoordinator = AppleSignInCoordinator(type: .signup)
    
    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    SignUpLabel
                    txtEmail.padding(.bottom,20)
                    txtPhoneNumber.padding(.bottom,20)
                    txtPassword.padding(.bottom,25)
                    txtConfirmPassword.padding(.bottom,25)
                    btnSignUp.padding(.bottom, 30)
                    TnCView.padding(.bottom, 30)
                    deviderView.padding(.bottom, 30)
                    socialLoginView.padding(.bottom,30)
                    bottomView.padding(.bottom,30)
                }.padding(.horizontal,20)
                NavigationLink(isActive: $navigateToView, destination: { EditProfileView(strFname: strFname, strLname: strLname, isSocailLogin: false) }, label: { EmptyView() })
            }
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.onReceive(appleSignup, perform: { output in
            strFname = "\(output.userInfo?["fname"] ?? "")"
            strLname = "\(output.userInfo?["lname"] ?? "")"
           // strEmail = "\(output.userInfo?["email"] ?? "")"
           // strPassword = "\(output.userInfo?["password"] ?? "")"
            signUpParam =  ["email" :  "\(output.userInfo?["email"] ?? "")",
               "password" : "\(output.userInfo?["password"] ?? "")",
                "phone_number" : "",
               "devicetokon" : strDeviceToken,]
            signUp()
        }).onDisappear{
            
        }
        .setNavigationBar(strTitle: "", isBackButton: false, isLogo: true)
        .background(Color.white)
    }
    
    private var SignUpLabel : some View{
        VStack{
            Text("Sign Up")
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
    private var txtPhoneNumber : some View{
        VStack {
            iPhoneNumberField(text: $strPhoneNumber)
                      .flagHidden(false)
                      .flagSelectable(true)
                      .setLightFont(color: .black)
        }
        .padding()
        .dropShadowAndCorner()
    }
    private var txtPassword : some View{
        HStack {
            Image("lock").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            if !showPassword{
                SecureField("Chooose Password", text: $strPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
            }
            else{
                TextField("Chooose Password", text: $strPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
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
    
    private var txtConfirmPassword : some View{
        HStack {
            Image("lock").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            if !showPassword1{
                SecureField("Confirm Password", text: $strConformPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
            }
            else{
                TextField("Confirm Password", text: $strConformPassword).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
            }
             
            Button(action: {
                        showPassword1.toggle()
                    }, label: {
                        Image(systemName: !showPassword1 ? "eye.fill" : "eye.slash.fill").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30).gradientForeground()
            })
            
        }
        .padding()
        .dropShadowAndCorner()
    }
    
    
    private var btnSignUp : some View{
        VStack {
            Button(action: {
                if !Utils.isValidEmail(strEmail ){
                    Utils.showToast(strMessage: "please enter valid email")
                }
                else if strPhoneNumber == "" {
                    Utils.showToast(strMessage: "please enter phone number")
                }
                else if strPassword.isEmpty {
                    Utils.showToast(strMessage: "please enter password")
                }
                else if strPassword != strConformPassword {
                    Utils.showToast(strMessage: "please enter valid confirm password")
                }
                else{
                    signUpParam = ["email" : strEmail,
                                   "phone_number" : strPhoneNumber ,
                               "password" : strPassword,
                               "devicetokon" : strDeviceToken, ]
                    signUp()
                }
              
            }, label: {
                Text("Sign Up")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
    private var TnCView : some View{
        VStack {
            (
            Text(" By proceeding you also agree to the ")
                .font(MainFont.medium.with(size: 16))
                .foregroundColor(Color.regularFontColor) +
                                                    
            Text("Terms of Service ")
                .font(MainFont.medium.with(size: 15))
                .foregroundColor(Color.lightBlueColor)

            +
            
            Text("and ")
                .font(MainFont.medium.with(size: 16))
                .foregroundColor(Color.regularFontColor) +
                                                    
            Text("Privacy Policy")
                .font(MainFont.medium.with(size: 15))
                .foregroundColor(Color.lightBlueColor)
            )
            .multilineTextAlignment(.center)
                   
        }
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
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                (
                    Text("Already have an account ? ")
                        .font(MainFont.medium.with(size: 16))
                        .foregroundColor(Color.regularFontColor) +
                    
                    Text("Sign in")
                        .font(MainFont.medium.with(size: 15))
                        .foregroundColor(Color.lightBlueColor)
                )   .multilineTextAlignment(.center)
            })
            
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
           
             signUpParam =  ["email" :   myUser.profile?.email ?? "",
                "password" : myUser.userID ?? "",
                "phone_number" : "" ,
                "devicetokon" : strDeviceToken,]
                signUp()
         })
    }
    
    //MARK: -  apple login
    func performSignInWithApple() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = appleSignInCoordinator
            authorizationController.performRequests()
        }
    
    
    //MARK: - Api Calls
    func signUp(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .register) , param: signUpParam, completion: { responseData,code in
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
                            Utils.storeDataInLocal(key: .isNotificationOn, model.sendNotification ?? "")
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
