//
//  Constant.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//

import UIKit
import SwiftUI

//MARK: -  global variable
let appName = "TutumNet"
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var strDeviceToken = ""
var successCode = "1"
var defaultImage: Image = Image("imagePlaceholder")
var arrAnswerId = [[Int]]()
var arrWrongQueID = [Int]()
var strSleepHour = ""
var isAnswerSubmit : Bool?
var arrGoals = GoalSelectionModel()
var arrQuestion = QuestionModel()
{
    didSet{
        arrAnswerId = []
        arrWrongQueID = []
        strSleepHour = ""
        arrQuestion.data?.forEach { que in
            isAnswerSubmit = (que.answerselected ?? false) ? true : false
            var arr = [Int]()
            let goalQuestionObject = que
            if goalQuestionObject.answerselected ?? false{
                let goalQuestion = goalQuestionObject.goalQuestions ?? []
                let questionId = goalQuestion[0].id ?? 0
                let answers = goalQuestion[0].getAnswers ?? []
                let selectedAnsId = goalQuestion[0].selectedanswerid
                if goalQuestionObject.goalTitle == "Sleep"{
                    strSleepHour = goalQuestion[0].inputvalue?[0] ?? ""
                }
                for ans in answers{
                    if selectedAnsId?.contains(ans.id ?? 0) ?? false  && ans.answertype == answerType.wrongAnswer.rawValue
                    {
                        arrWrongQueID.append(questionId)
                    }
                }
                selectedAnsId?.forEach { id in
                    arr.append(id)
                }
                arrAnswerId.append(arr)
            }
            else{
                arrAnswerId.append(arr)
            }
        }
    }
}



//MARK: - screen measurement
enum screenSize {
   static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}

//MARK: -  enum

enum settingItems : String{
    case profile = "Profile"
    case myNetwork = "My Network"
    case myInvite = "My Invitation"
    case notification = "Notification"
    case deleteAccount = "Delete Account"
    case logout = "Logout"
}

enum homeItems : String{
    case goalSelection = "Goal Selection"
    case network = "Network"
    case dailyTracking = "Daily Tracking"
    case historycalResult = "Historical Results"
    case settings = "Settings"
}

enum networkType: String{
    case friends = "F"
    case parentsCartaker = "PC"
    case doctorTherapists = "D"
    
    init?(stringValue: String) {
        switch stringValue {
            case "F":
                self = .friends
            case "PC":
                self = .parentsCartaker
            case "D":
                self = .doctorTherapists
            default:
                return nil
        }
    }
    
    
    var image: String{
        switch self {
        case .friends:
            return "friends"
        case .parentsCartaker:
            return "parents"
        case .doctorTherapists:
            return "doctors"
        }
    }
    
    var title : String{
        switch self {
        case .friends:
            return "Friend"
        case .parentsCartaker:
            return "Family"
        case .doctorTherapists:
            return "Doctor"
        }
    }

    func getImageAndTitle() -> (String, String) {
       return (image, title)
   }

}

enum questionType : String{
    case normal = "normal"
    case input = "input"
    case msg = "msg"
}


enum gender : String {
    case male = "M"
    case female = "F"
    case noBinary = "NB"
    case noAnswer = "NO"
    
    init?(stringValue: String) {
        switch stringValue {
        case "M":
            self = .male
        case "F":
            self = .female
        case "NB":
            self = .noBinary
        case "NO":
            self = .noAnswer
        default:
            return nil
        }
    }
}

enum answerType : String{
    case correctAnswer
    case wrongAnswer
    case partialAnswer
}

enum ansColor : String  {
    case correctAnswer = "correctAnswer"
    case wrongAnswer = "wrongAnswer"
    case partialAnswer = "partialAnswer"
    
    var color : Color{
        switch self {
            case .correctAnswer : return .green
            case .wrongAnswer : return .red
            case .partialAnswer : return .yellow
        }
    }
    
    init?(stringValue: String) {
        switch stringValue {
            case "correctAnswer":
                self = .correctAnswer
            case "wrongAnswer":
                self = .wrongAnswer
            case "partialAnswer":
                self = .partialAnswer
            default:
                return nil
        }
    }
    
    func getAnsColor() -> Color {
        return color
    }
    
}



//MARK: - keys
typealias userKey = keys.UserDefaultKeys
typealias messageKey = keys.MessagesKeys

enum keys
{
    enum UserDefaultKeys : String
    {
        case isWelcomeShown = "isWelcomeShown"
        case accessToken = "token"
        case isNotificationOn = "send_notification"
    }
    enum MessagesKeys
    {
        static let somethingWrong = "Something went wrong"
        static let noInternet = "Please check your internet"
    }
}


//MARK: -  functions
final class Router {

    //MARK: Main flow.
    public static func showMain(window: UIWindow? = nil, view : any View ) {
        Router.setRootView(view: view, window: window)
    }

    //MARK: private
    private static func setRootView<T: View>(view: T, window: UIWindow? = nil) {
        if window != nil {
            let nav = UINavigationController.init(rootViewController: UIHostingController(rootView: view))
            
            window?.rootViewController =  nav
            UIView.transition(with: window!,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            return
        }else {
            let nav = UINavigationController.init(rootViewController: UIHostingController(rootView: view))
            UIApplication.shared.keyWindow?.rootViewController = nav
            UIView.transition(with: UIApplication.shared.keyWindow!,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

}


func navigateToLogin(){
    [userKey.isNotificationOn.rawValue, userKey.accessToken.rawValue].forEach{
        Utils.removeLocalStorageData(key: $0)
    }
    Router.showMain(view: LoginView())
}
