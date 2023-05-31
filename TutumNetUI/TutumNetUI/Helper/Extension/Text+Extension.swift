//
//  Text+Extension.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import SwiftUI
import UIKit

extension AttributedString {
    init(_ string: String, color: Color, forSubstring substring: String) {
        let attributedString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: substring)
        attributedString.addAttribute(.foregroundColor, value: UIColor(color), range: range)
        self.init(attributedString)
    }
}

extension Text {
    init(_ string: String, color: Color, forSubstring substring: String) {
        self.init(AttributedString(string, color: color, forSubstring: substring))
    }
}

