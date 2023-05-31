//
//  WelcomeModel.swift
//  MentalHealthApp
//
//  Created by Apple on 27/10/22.
//


struct welcomeModel : Hashable {
    var id: Int
    let description: String
    let imageName: String
    
    static let menuItems: [welcomeModel] = [
        welcomeModel(id: 1, description: "Defining and tracking your self-care goals drives emotional self-awareness which has been shown to reduce symptoms of mental illness and improve coping skills.", imageName: "welcome-1"),
        welcomeModel(id: 2, description: "Select the goals you want to track daily (Sleep, Mindfulness, Medication, Exercise, Socialization and Personal Hygiene)", imageName: "welcome-2"),
        welcomeModel(id: 3, description: "Track your daily goals", imageName: "welcome-3"),
        welcomeModel(id: 4, description: "If you are ever missing your goals at an alarming rate, let us contact your support network to help you out", imageName: "welcome-4"),
        welcomeModel(id: 5, description: "Track your goal history", imageName: "welcome-5"),
    ]
    
    
}
