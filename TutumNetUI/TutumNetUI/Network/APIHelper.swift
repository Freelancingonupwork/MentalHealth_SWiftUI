//
//  APIHelper.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import Alamofire
import Foundation
import UIKit

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}
typealias ResultHandler =   (_ responseData: (Data), _ code:String)->()


class APIHelper{
    
    //MARK: -  variable
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    static let sharedInstance = APIHelper()
    private var commonHeaders: HTTPHeaders {
        return [
            "Authorization": "Bearer \(Utils.getDataFromLocal(key: .accessToken))"
        ]
    }
    
    private init(){
        
    }
    
    func request( methodType : HTTPMethod, url : String, param : [String:Any], completion: @escaping ResultHandler){
        print("apiurl - ", url)
        print("param - \(param)")
        
        AF.request(url, method: methodType, parameters: param, encoding: URLEncoding.default, headers: commonHeaders).responseData{ (response:DataResponse)  in
            print("response - \(response)")
          switch(response.result) {
              case .success(_):
                      let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                      if let json = jsonSerialized{
                          print("response json - \(json)")
                          if "\(json["status"] ?? "0")"  == "1" ||   "\(json["status"] ?? "0")"  == "0"
                          {
                              completion(response.data ?? Data(), successCode)
                          }
                          else{
                              completion(response.data ?? Data(), "\(json["message"] as? String ?? "")")
                          }
                      }
                  break
              case .failure(_):
                !Connectivity.isConnectedToInternet() ? Utils.showToast(strMessage: messageKey.noInternet) :
                      Utils.showToast(strMessage: messageKey.somethingWrong)
                  break
          }
      }
    }
    
    func requestJSON( methodType : HTTPMethod, url : String, param : [String:Any], completion: @escaping ResultHandler){
        print("apiurl - ", url)
        print("param - \(param)")
        
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(commonHeaders)", forHTTPHeaderField: "Authorization")
        request.httpMethod = methodType.rawValue
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        AF.request(request).responseData(completionHandler: {response in
          print("response - \(response)")
          switch(response.result) {
              case .success(_):
                      let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                      if let json = jsonSerialized{
                          print("response json - \(json)")
                          if "\(json["status"] ?? "0")"  == "1" ||   "\(json["status"] ?? "0")"  == "0"
                          {
                              completion(response.data ?? Data(), successCode)
                          }
                          else{
                              completion(response.data ?? Data(), "\(json["message"] as? String ?? "")")
                          }
                      }
                  break
              case .failure(_):
              !Connectivity.isConnectedToInternet() ? Utils.showToast(strMessage: messageKey.noInternet) :
                    Utils.showToast(strMessage: messageKey.somethingWrong)
                  break
          }
        })
    }
 
    func request( methodType : HTTPMethod, url : String, param : [String:Any], image : UIImage, completion: @escaping ResultHandler){
        print("apiurl - ", url)
        print("param - \(param)")
        
        AF.upload(multipartFormData: { multipartFormData in
           if let imageData = image.jpegData(compressionQuality: 0.6) {
               multipartFormData.append(imageData, withName: "userprofileimage", fileName: "userprofileimage.png", mimeType: "image/png")
           }
           for (key, value) in param {
               multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
           }
        }, to: url, method: .post, headers: commonHeaders ).response(completionHandler: { (response:DataResponse)  in
            print("response - \(response)")
            switch(response.result) {
                case .success(_):
                    let jsonSerialized = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                    if let json = jsonSerialized{
                        print("response json - \(json)")
                        if "\(json["status"] ?? "0")"  == "1" ||   "\(json["status"] ?? "0")"  == "0"
                        {
                            completion(response.data ?? Data(), successCode)
                        }
                        else{
                            completion(response.data ?? Data(), "\(json["message"] as? String ?? "")")
                        }
                    }
                    break
                case .failure(_):
                !Connectivity.isConnectedToInternet() ? Utils.showToast(strMessage: messageKey.noInternet) :
                      Utils.showToast(strMessage: messageKey.somethingWrong)
                    break
            }
        })
    }
}
