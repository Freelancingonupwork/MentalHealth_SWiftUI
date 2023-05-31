//
//  ApiKeys.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import Foundation





//MARK: - server url
struct Domain {
    static let dev = "http://13.235.245.24"
    static let live = "http://www.tutumnet.com"

}

extension Domain {
    static func baseUrl() -> String {
        return "\(Domain.dev)"
    }
}

struct Url{
    static func apiurl(apiEndPoint : APIEndpoint, extra : String = "") -> String{
        return "\(String(describing: Domain.baseUrl()))/api/\(apiEndPoint.rawValue)" + (extra != "" ? "/\(extra)" : "")
    }
}

//MARK: - endpoint

enum APIEndpoint : String
{
    case login = "auth/login"
    case register = "auth/register"
    case forgotPassword = "auth/forgot-password"
    case resetPassword = "auth/reset-password"
    case getProfile = "profile/get"
    case profileUpdate = "profile/update"
    case saveEditDeleteNetwork = "contacts"
    case showAllNetwork = "contacts/show"
    //case getNetwork = "contacts/3/edit"
    //case updateDeleteNetwork = "contacts/"
    case getAllGoal = "goals"
    case goalSelection = "goals/selection"
    case getSelectedGoal = "goals/selected"
    case getQuestions = "goals/questions"
    case submitAnswers = "tracktodayshealth"
    case updateAnswers =  "updatetracktodayshealth"
    case trackingreport = "trackingreport"
    case deleteAccount = "auth/deleteaccount"
    case isContactExists = "contacts/verify"
    case privacyPolicy = "http://www.tutumnet.com/privacy-policy"
    case notificationStatus = "profile/notification"
    case getAllInvitation = "contacts/get/waiting-invites"
    case resendInvitation = "contacts/resend/invite"
}
