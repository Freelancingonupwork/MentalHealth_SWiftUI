//
//  Font+Extension.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//

import SwiftUI


typealias MainFont = AppFont.Roboto

enum AppFont {
    enum Roboto: String {
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
        
        func with(size: CGFloat) -> Font {
            return Font.custom("\(rawValue)", size: size)
        }
    }
}
