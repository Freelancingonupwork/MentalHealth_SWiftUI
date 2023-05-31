//
//  LoaderView.swift
//  TutumNetUI
//
//  Created by Apple on 25/05/23.
//

import SwiftUI
import Lottie

struct LottieLoaderView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let animationName: String = "loader"
    let animationView = LottieAnimationView()

    
    func makeUIView(context: Context) -> UIView {
       let view = UIView(frame: .zero)
       animationView.animation = LottieAnimation.named(animationName)
       animationView.contentMode = .scaleAspectFit
       animationView.loopMode = .loop
       animationView.play()
       view.addSubview(animationView)
       animationView.translatesAutoresizingMaskIntoConstraints = false
       animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
       animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
       return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
}
