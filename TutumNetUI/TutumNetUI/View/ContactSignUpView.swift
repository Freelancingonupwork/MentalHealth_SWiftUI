//
//  ContactSignUpView.swift
//  TutumNetUI
//
//  Created by Apple on 06/03/23.
//

import SwiftUI

struct ContactSinUpView : View{
    //MARK: -  variable
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    @State private var strName : String = ""
    @State private var strPhoneNumber : String = ""
    @State private var strEmail : String = ""
    @State private var imgNetwork = ""
    @State private var titleNetwork = ""
    @State private var i = 0
    @State private var contactParam = [[String:Any]]()
    @State private var networktype : networkType  = .friends
    @State private var arrPhoneContacts = [phoneContactModel]()
    @State private var arrContactName = [String]()
    @State private var showContactPicker = false
    @State private var showSettingPicker = false
    @State private var showContacts = false
    @State private var isDropdownExpanded: Bool = false
    
    var arrNetwork : [networkType]
    var fromNetworkList : Bool
    var dictNetwrok : NetworkModel.Datum
    private var filteredName: [String] {
        if strName.isEmpty {
            return arrContactName
        } else {
            return arrContactName.filter { $0.localizedCaseInsensitiveContains(strName) }
        }
    }
    @State private var isLoading = false
    
    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false) {
                    imgType
                    lblType
                    txtName
                    txtEmail
                    txtPhone
                    if arrNetwork.count > 0{
                        btnAddAnother
                    }
                    btnDone
                }
            }.padding(.all, 20)
            if isLoading {
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: "Contact Sign Up", isBackButton: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        }).onAppear{
            setTitle()
        }
    }
    
    private var imgType : some View{
        VStack{
            Image(imgNetwork)
                .resizable()
                .scaledToFit()
                .frame(height: screenSize.height/5)
                .padding(.bottom, 10)
        }
    }
    
    private var lblType : some View{
        VStack{
            Text(titleNetwork)
                .setFont(color: .primaryColor).padding(.bottom, 30)
        }
    }
    
    
    private var txtName : some View{
        VStack {
            HStack {
                Image("user").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
                TextField("Name*", text: $strName, onEditingChanged: { isEditing in
                    isDropdownExpanded = isEditing
                    prepareToLoad()
                }).keyboardType(.default).setLightFont(color: .black).padding(.trailing,10)
                Button(action: {
                    isDropdownExpanded = true
                    prepareToLoad()
                }, label: {
                    Image("add-goal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                })
            }
            .padding()
            .dropShadowAndCorner()
            .padding(.bottom, 10)
            if isDropdownExpanded {
                DisclosureGroup(
                    isExpanded: $isDropdownExpanded,
                    content: {
                        VStack(alignment: .leading) {
                            ForEach(filteredName, id: \.self) { option in
                                Button(action: {
                                    print(option )
                                    let originaConact = arrPhoneContacts.filter( { "\($0.name ?? "") - \( ($0.phoneNumber.count ) > 0 ? $0.phoneNumber[0] : "" )" == option }).first
                                    strName = originaConact?.name ?? ""
                                    strEmail = originaConact?.email.first ?? ""
                                    strPhoneNumber = originaConact?.phoneNumber.first ?? ""
                                    isDropdownExpanded = false
                                }) {
                                    HStack{
                                        Text(option ).setLightFont(color: .regularFontColor)
                                        Spacer()
                                    }
                                }//.padding(.all, 2)
                                    .padding([.leading,.trailing],10)
                                    .padding([.top,.bottom], 5)
                            }
                           
                        }.padding(.all, 10)
                        .background(.white)
                        .dropShadowAndCorner()
                    },
                    label: {
                        Text("Select Contact").setFont(color: .regularFontColor)
                    }
                )
            }
        }
    }
    
    private var txtEmail : some View{
        HStack {
            Image("email").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField(networktype == .doctorTherapists ? "Email*" : "Email", text: $strEmail).keyboardType(.emailAddress).setLightFont(color: .black).padding(.trailing,10)
            
        }
        .padding()
        .dropShadowAndCorner()
        .padding(.bottom, 10)
    }
    
    private var txtPhone : some View{
        HStack {
            Image("call").resizable().scaledToFit().padding(.trailing,5).frame(width: 30, height: 30)
            TextField("Phone*", text: $strPhoneNumber).keyboardType(.phonePad).setLightFont(color: .black).padding(.trailing,10)
        }
        .padding()
        .dropShadowAndCorner()
        .padding(.bottom, 30)
    }
    
    private var btnAddAnother : some View{
        VStack{
            VStack {
                Button(action: {
                    if strName.isEmpty {
                        Utils.showToast(strMessage: "please enter name")
                    }
                    else if networktype != .doctorTherapists && (!strEmail.isEmpty) && !Utils.isValidEmail((strEmail)) {
                        Utils.showToast(strMessage: "please enter valid email")
                    }
                    else if !Utils.isValidEmail(strEmail) && networktype == .doctorTherapists {
                        Utils.showToast(strMessage: "please enter valid email")
                    }
                    else if strPhoneNumber.isEmpty{
                        Utils.showToast(strMessage: "please enter phone")
                    }
                    else{
                        isContactExists(param: ["phonenumber" : removeSpecialCharsFromString(text: String(strPhoneNumber.filter { !" \n\t\r".contains($0) })), "email" : strEmail], completion: { bool in
                            if bool{
                                appendNetwork()
                                resetFields()
                            }
                            else{
                                resetFields()
                            }
                        })
                    }
                }, label: {
                    Text("+ Add Another \(arrNetwork[i].title)")
                        .font(MainFont.bold.with(size: 18))
                        .foregroundColor(.white)
                    
                }).frame(height: 50)
            }.frame(maxWidth : .infinity)
                .gradientBackround()
                .cornerRadius(10)
                .padding(.bottom, 10)
        }
    }
    private var btnDone : some View{
        VStack{
            VStack {
                Button(action: {
                    if strName.isEmpty {
                        Utils.showToast(strMessage: "please enter name")
                    }
                    else if networktype != .doctorTherapists && (!strEmail.isEmpty) && !Utils.isValidEmail((strEmail)) {
                        Utils.showToast(strMessage: "please enter valid email")
                    }
                    else if !Utils.isValidEmail(strEmail) && networktype == .doctorTherapists {
                        Utils.showToast(strMessage: "please enter valid email")
                    }
                    else if strPhoneNumber.isEmpty{
                        Utils.showToast(strMessage: "please enter phone")
                    }
                    else{
                        if arrNetwork.count > 0{
                            isContactExists(param: ["phonenumber" : removeSpecialCharsFromString(text: String(strPhoneNumber.filter { !" \n\t\r".contains($0) })), "email" : strEmail], completion: { bool in
                                if bool{
                                    appendNetwork()
                                }
                                
                                if i != arrNetwork.count - 1{
                                    i += 1
                                    setTitle()
                                    resetFields()
                                }
                                else{
                                    if contactParam.count > 0{
                                        saveNetwork()
                                    }
                                }
                            })
                        }
                        else{
                            updateNetwork()
                        }
                        
                    }
                }, label: {
                    Text("Done")
                        .font(MainFont.bold.with(size: 18))
                        .foregroundColor(.white)
                    
                }).frame(height: 50)
            }.frame(maxWidth : .infinity)
                .background(Color.primaryColor )
                .cornerRadius(10)
                .padding(.bottom, 30)
        }
    }
    
    //MARK: -  function
    
    func prepareToLoad(){
        print("prepare to load call")
        ContactPermission.requestContactPermissions(completion: { bool in
            if bool {
                if arrPhoneContacts.isEmpty {
                     loadContacts()
                }
            }
            else{
                showSettingPicker.toggle()
            }
        })
    }

    func loadContacts() {
        arrPhoneContacts.removeAll()
        var allContacts = [phoneContactModel]()
        for contact in phoneContacts.getContacts() {
            if (!contact.familyName.isEmpty || !contact.givenName.isEmpty) && contact.phoneNumbers.count != 0{
                allContacts.append(phoneContactModel(contact: contact))
            }
        }
        arrPhoneContacts.append(contentsOf: allContacts)
        arrPhoneContacts = arrPhoneContacts.sorted(by: { $0.name ?? "" < $1.name ?? ""} )
        arrContactName.removeAll()
        for contact in arrPhoneContacts {
            arrContactName.append("\(contact.name ?? "") - \( (contact.phoneNumber.count ) > 0 ? contact.phoneNumber[0] : "" )")
        }
    }
    
    
    func appendNetwork(){
        let param = ["name" : strName,
                     "email" : strEmail,
                     "phonenumber" : removeSpecialCharsFromString(text: String(strPhoneNumber.filter { !" \n\t\r".contains($0) })),
                     "contacttype" : arrNetwork[i].rawValue ]
        contactParam.append(param)
        //resetFields()
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("0123456789 +")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func resetFields()
    {
        strName = ""
        strEmail = ""
        strPhoneNumber = ""
    }
    
    func setTitle(){
        if arrNetwork.count > 0{
            networktype = arrNetwork[i]
            imgNetwork = arrNetwork[i].image
            titleNetwork = arrNetwork[i].title
        }
        else{
            strName = dictNetwrok.name ?? ""
            strEmail = dictNetwrok.email ?? ""
            strPhoneNumber = dictNetwrok.phoneNumber ?? ""
            networktype = networkType.init(stringValue: dictNetwrok.type ?? "") ?? .friends
            imgNetwork = networktype.getImageAndTitle().0
            titleNetwork = networktype.getImageAndTitle().1
        }
    }
    
    //MARK: - api call
    
    func isContactExists(param  : [String:Any], completion : @escaping(Bool) -> () ) {
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .isContactExists), param: param, completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    if model.status{
                        completion(true)
                    }
                }
                catch{
                    print(error.localizedDescription)
                    Utils.showToast(strMessage: messageKey.somethingWrong)
                    completion(false)
                }
            }
            else{
                Utils.showToast(strMessage: code)
                completion(false)
            }
        })
    }
    func saveNetwork(){
        isLoading.toggle()
        var param = [String:Any]()
        param = ["contacts" : contactParam]
        APIHelper.sharedInstance.requestJSON(methodType: .post, url: Url.apiurl(apiEndPoint: .saveEditDeleteNetwork), param: param, completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    if model.status{
                        Utils.showToast(strMessage: model.message ?? "")
//                        if fromNetworkList{
//                            NotificationCenter.default.post(name: .updateNetwork, object: nil)
//                            presentationMode.wrappedValue.dismiss()
//                            presentationMode.wrappedValue.dismiss()
//
//                        }
//                        else{
//                            Router.showMain(view: HomeView())
//                        }
                        Router.showMain(view: HomeView())
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
    func updateNetwork(){
        isLoading.toggle()
        let param : [String:Any] = ["name" : strName,
                                    "email" : strEmail,
                                    "phone_number" : strPhoneNumber,
                                    "type" : networktype.rawValue ]
        APIHelper.sharedInstance.request(methodType: .put, url: Url.apiurl(apiEndPoint: .saveEditDeleteNetwork, extra: "\(dictNetwrok.id ?? 0)"), param: param, completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    if model.status{
                        Utils.showToast(strMessage: model.message ?? "")
                        NotificationCenter.default.post(name: .updateNetwork, object: nil)
                        presentationMode.wrappedValue.dismiss()
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
struct ContactSinUpView_Previews : PreviewProvider{
    static var previews: some View{
        ContactSinUpView(arrNetwork: [.friends], fromNetworkList: false, dictNetwrok: NetworkModel.Datum(id: 0, name: "", email: "", phoneNumber: "", userID: 0, type: "", isverified: "", verificationcode: "") )
    }
}
