//
//  EditProfileView.swift
//  TutumNetUI
//
//  Created by Apple on 22/02/23.
//

import SwiftUI
import iPhoneNumberField
import UIKit
import SDWebImageSwiftUI


struct EditProfileView : View{
    //MARK: - variable
    @State var strFname : String //= ""
    @State var strLname : String //= ""
    @State private var strDob = ""
    @State private var strPhoneNumber : String = ""
    @State private var genderValue : gender = .female
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
        formatter.dateFormat =  "MM/dd/yyyy"
            return formatter
        }()
    @State private var selectedDate = Date(){
        didSet{
            strDob = dateFormatter.string(from: selectedDate)
        }
    }
    @State private var showActionSheet = false
    @State private var showDatePicker = false
    @State private var showSettingPicker = false
    @State private var profileImage : UIImage!// UIImage(named: "add-user")
    var defaultImage: Image = Image("add-user")
    @State private var imageUrl: String = ""
    @State private var showImagePicker = false
    @State private var isCamera = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var isSocailLogin : Bool?// false
    @State private var navigateToView = false
    @State private var isLoading = false


    //MARK: -  view
    var body : some View{
        ZStack{
                VStack{
                    Rectangle().fill(Color.clear).frame(height: 50)
                    ScrollView{
                        imgProfile.padding(.bottom,10)
                        lblUsername.padding(.bottom,30)
                        txtFname.padding(.bottom,20)
                        txtLname.padding(.bottom,20)
                        txtPhoneNumber.padding(.bottom,20)
                        lblGender.padding(.bottom,20)
                        radioGender.padding(.bottom,20)
                        lblIWasBorn.padding(.bottom,20)
                        txtDob.padding(.bottom,20)
                        btnSubmit.padding(.bottom)
                    }
                    .padding(.horizontal, 20)
                    .background(Color.white)
                }
                if isLoading{
                    Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                    LottieLoaderView().frame(width: 300, height: 300)

                }
                NavigationLink(isActive: $navigateToView, destination: { SignInOptionView() }, label: { EmptyView() })
        }
        .setNavigationBar(strTitle: "You", backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
        .onAppear{
            getProfile()
        }
    }
    
    private var imgProfile : some View{
        VStack{
            Button(action: {
                showActionSheet.toggle()
            }, label: {
                AsyncImage(url: URL(string: imageUrl )) { image in
                    image.resizable().aspectRatio(contentMode: .fill).frame(width: 120, height: 120).background(Color.red).cornerRadius(60).overlay(content: {
                        if profileImage != nil{
                            Image(uiImage: self.profileImage!)
                             .resizable()
                             .cornerRadius(60)
                             .frame(width: 120, height: 120)
                             .aspectRatio(contentMode: .fill)
                             .clipShape(Circle())
                        }
                    })
                }placeholder: {
                    if profileImage != nil{
                        Image(uiImage: self.profileImage!) .resizable() .cornerRadius(60).frame(width: 120, height: 120).clipShape(Circle())
                    }
                    else{
                        defaultImage.resizable().aspectRatio(contentMode: .fill).cornerRadius(60).frame(width: 120, height: 120)
                    }
                }
            }).sheet(isPresented: $showImagePicker, content: {
                ImagePicker(sourceType: isCamera ? .camera : .photoLibrary, selectedImage: $profileImage)
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                Utils.getImageActionsSheet(cameraAction: { bool in
                    if bool{
                        isCamera = true
                        showImagePicker.toggle()
                    }
                    else{
                        showSettingPicker.toggle()
                    }
                }, galleryAction: { bool in
                    if bool{
                        isCamera = false
                        showImagePicker.toggle()
                    }
                    else{
                        showSettingPicker.toggle()
                    }
                })
            })
            .alert(isPresented: $showSettingPicker, content: {
                Utils.showAlert(msg: "please grant the permission", positiveAction: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }, negativeAction: {
                    showSettingPicker.toggle()
                })
            })
        }
    }
    private var lblUsername : some View {
        VStack{
            Text("I am")
                .setFont(color: .primaryColor)
        }
    }
    private var txtFname : some View{
        HStack {
            Image("user").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField("First Name", text: $strFname).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
        }
        .padding()
        .dropShadowAndCorner()
    }
    private var txtLname : some View{
        HStack {
            Image("user").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField("Last Name", text: $strLname).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
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
    private var lblGender : some View {
        VStack{
            Text("Gender")
                .setFont(color: .primaryColor)
                
        }.frame(maxWidth: .infinity,alignment: .leading)
    }
    private var radioGender : some View {
        VStack{
            HStack{
                VStack{
                    Button(action: {
                        genderValue = .female
                    }, label: {
                        HStack{
                            Image(genderValue == .female ?  "checked" : "unchecked")
                            Text("Female").setLightFont(color: .primaryColor)
                        }
                    }).tag(1)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                VStack{
                    Button(action: {
                        genderValue = .noBinary
                    }, label: {
                        HStack{
                            Image(genderValue == .noBinary ?  "checked" : "unchecked")
                            Text("Non-Binary").setLightFont(color: .primaryColor)
                        }
                    }).tag(2)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
            }.padding(.bottom,10)
            HStack{
                VStack{
                    Button(action: {
                        genderValue = .male
                    }, label: {
                        HStack{
                            Image( genderValue == .male ?  "checked" : "unchecked")
                            Text("Male").setLightFont(color: .primaryColor)
                        }
                    }).tag(3)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                VStack{
                    Button(action: {
                        genderValue = .noAnswer
                    }, label: {
                        HStack{
                            Image(genderValue == .noAnswer ?  "checked" : "unchecked")
                            Text("Prefer No to Answers").setLightFont(color: .primaryColor)
                        }
                    }).tag(4)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }.frame(maxWidth: .infinity,alignment: .leading)
    }
    private var lblIWasBorn : some View {
        VStack{
            Text("I was born on?")
                .setFont(color: .primaryColor)
                
        }.frame(maxWidth: .infinity,alignment: .leading)
    }
    private var txtDob : some View{
 
        HStack {
            Image("calender").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField("mm/dd/yyyy", text: $strDob , onEditingChanged: { editing in
                self.showDatePicker = editing
            }).setLightFont(color: .black)
            if self.showDatePicker {
                DatePicker("",
                    selection: Binding(get: {selectedDate}, set:{
                       selectedDate = $0
                       UIApplication.shared.endEditing()   
                    }),
                    displayedComponents: .date)
                    .padding(.horizontal)
                    .frame(width: screenSize.width-105)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
            }
        }
        .padding()
        .dropShadowAndCorner()

    }
    private var btnSubmit : some View{
        VStack {
            Button(action: {
                if strFname.trimmingCharacters(in: .whitespaces).count == 0{
                    Utils.showToast(strMessage: "please enter the first name")
                }
                else if strLname.trimmingCharacters(in: .whitespaces).count == 0{
                    Utils.showToast(strMessage: "please enter the lname name")
                }
                else if strPhoneNumber.trimmingCharacters(in: .whitespaces).count == 0{
                    Utils.showToast(strMessage: "please enter the mobile name")
                }
                else if strDob.trimmingCharacters(in: .whitespaces).count == 0{
                    Utils.showToast(strMessage: "please enter the DOB")
                }
                else{
                    saveProfile()
                }
                //moveToNext()
                
            }, label: {
                Text("Submit")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
                
            }).frame(height: 50)
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
    //MARK: -  move to next
    func moveToNext(){
        if isSocailLogin ?? false{
            Router.showMain(view: HomeView())
        }
        else if !(isSocailLogin ?? true){
            navigateToView.toggle()
        }
    }
    
    //MARK: - api call
    
    func getProfile(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .getProfile), param: [:], completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(ProfileModel.self, from: responseData)
                        if model.status{
                            let data = model.data
                            strFname = data?.firstName ?? ""
                            strLname = data?.lastName ?? ""
                            strPhoneNumber = data?.phoneNumber ?? ""
                            strDob = data?.dob ?? ""
                            imageUrl = data?.userprofileimage ?? ""
                            if let myEnumValue = gender(stringValue: data?.gender ?? "") {
                                genderValue = myEnumValue
                            }
                            
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
    
    func saveProfile(){
        isLoading.toggle()
        let param : [String : Any] = ["firstname" : strFname,
                     "lastname" : strLname,
                    "gender" : genderValue.rawValue,
                     "dob" : strDob,
                    "phone_number" : strPhoneNumber]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .profileUpdate), param: param, image: profileImage ?? UIImage(), completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(ProfileModel.self, from: responseData)
                        if model.status{
                            Utils.showToast(strMessage: model.message ?? "")
                           moveToNext()
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
//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//    }
//}
    
