//
//  WelcomeView.swift
//  TutumNetUI
//
//  Created by Apple on 22/02/23.
//

import SwiftUI


struct WelcomeView : View{
    
    //MARK: -  variable
    var arrWelcomeData = welcomeModel.menuItems
     var gridItemLayout = [GridItem(.flexible())]
    
    //MARK: -  view
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .link
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        ZStack{
           // NavigationView{
                VStack{
                    Rectangle().fill(Color.clear).frame(height: 50)
                    Spacer()
                    VStack{
                        TabView{
                            ForEach(arrWelcomeData, id: \.self) { datum in
                                WelcomeViewCell(welcomeData: datum)
                                    .padding(.bottom,20)
                            }
                        }
                            .tabViewStyle(PageTabViewStyle())
                    }.background(Color.clear)
                    HStack(spacing: 20){
                        btnSignIn
                        btnSignUp
                    }.padding([.horizontal,.bottom], 20)
                }.onAppear{
                    Utils.storeDataInLocal(key: .isWelcomeShown, true)
                }
                .padding(.bottom,20)
                    .setNavigationBar(strTitle: "", isBackButton: false, isLogo: true)
            //}
        }
            
    }
    
    private var btnSignIn : some View{
        VStack {
            NavigationLink(destination: LoginView( )){
                    Text("Sign In")
                        .font(MainFont.bold.with(size: 18))
                        .foregroundColor(.white)

               .frame(height: 50)
            }
        }.frame(maxWidth : .infinity)
            .background(Color.primaryColor)
            .cornerRadius(10)
    }
    
    private var btnSignUp : some View{
        VStack {
            NavigationLink(destination: RegisterView()){
                Text("Sign Up")
                    .font(MainFont.bold.with(size: 18))
                    .foregroundColor(.white)
            .frame(height: 50)
            }
        }.frame(maxWidth : .infinity)
            .gradientBackround()
            .cornerRadius(10)
    }
    
}

//MARK: -  preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView( )
    }
}
