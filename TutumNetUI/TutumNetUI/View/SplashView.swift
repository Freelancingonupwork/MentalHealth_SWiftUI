//
//  splashView.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//


import SwiftUI


struct SplashView : View{
    
    //MARK: - variable
    @State var isActive: Bool = false
    
    //MARK: -  navigation bar
    init() {
        let image = UIImage(named: "header")
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font : UIFont(name: MainFont.bold.rawValue, size: 22) ]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundImage = image
        navBarAppearance.backgroundImageContentMode = .scaleAspectFill
        navBarAppearance.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    
    //MARK: - body
    var body: some View{
        ZStack {
            //NavigationView{
                if isActive{
                    NavigationView{
                        if (Utils.getDataFromLocal(key: .isWelcomeShown) as? Bool ?? false) == true{
                            if (Utils.getDataFromLocal(key: .accessToken) as? String ?? "")  != "" {
                                HomeView()
                            }
                            else{
                                LoginView()
                            }
                        }
                        else{
                            WelcomeView()
                        }
                    }
                }
                else{
                    Image("splash")
                        .resizable()
                        .scaledToFill()
                }
            //}
        }.ignoresSafeArea(.all)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.02){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
    }
}

//MARK: - preview
struct splashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
