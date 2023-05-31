//
//  View+Extension.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//

import SwiftUI
import Combine

extension View {

    //MARK: - shadow
    func dropShadowAndCorner(color : Color = Color.btnBorder) -> some View {
        self .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(color))
        
    }
    
    //MARK: - gradient font
    public func gradientForeground() -> some View {
        self.overlay(
            LinearGradient(
                colors: [Color.init(hex: "#3264ED"), Color.init(hex: "#00B9FB")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
            .mask(self)
    }
    public func gradientBackround() -> some View {
        self.background(
            LinearGradient(
                colors: [Color.init(hex: "#3264ED"), Color.init(hex: "#00B9FB")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
           // .mask(self)
    }

    //MARK: - set font
    public func setFont(color : Color, font : CGFloat? = 16) -> some View{
        self.font(MainFont.medium.with(size: font ?? 16))
            .foregroundColor(color)
    }
    public func setLightFont(color : Color) -> some View{
        self.font(MainFont.regular.with(size: 16))
            .foregroundColor(color)
    }

    //MARK: - navigation bar
    func setNavigationBar(strTitle : String, isBackButton : Bool? = true, isTrailingButton : Bool? = false, trailingImg : String = "", isTrailingImg: Bool = true, isLogo : Bool? = false, backButtonAction: @escaping() -> Void = {}, trailingButtonAction: @escaping() -> Void = {}) -> some View{
        self
                    .navigationTitle(strTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                            ToolbarItem(placement: .principal) {
                                if isLogo ?? false{
                                    Image( "logo-unfill").resizable()
                                        .frame(maxWidth: screenSize.width/3, maxHeight: screenSize.height/20)
                                }
                            }
                        }
                    .navigationBarItems(leading: Button(action: {
                        if isBackButton ?? true{
                            backButtonAction()
                        }
                    }) {
                        if isBackButton ?? true{
                            Image(systemName:"chevron.backward")
                                .renderingMode(.template)
                                .foregroundColor(Color.white)
                        }
                    }, trailing: Button(action: {
                        if isTrailingButton ?? false{
                            trailingButtonAction()
                        }
                    }) {
                        if isTrailingButton ?? false{
                    
                            if isTrailingImg {
                                Image(systemName:  trailingImg).resizable().foregroundColor(.white)
                            }
                        }
                    })
    }
    
    //MARK: - toggle
        
}

