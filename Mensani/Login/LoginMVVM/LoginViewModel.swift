//
//  LoginViewModel.swift
//  Mensani
//
//  Created by apple on 09/05/23.
//

import Foundation
import SwiftyJSON


class LoginViewModel : LoginProtocol
{
    var strDeviceToken = ""
    var delegate: LoginResponseDelegate?
    func sendValues(email : String? , password : String? , token : String? , controller : UIViewController)
     {
         guard let emailAddress = email else
         {
             return
         }
         guard let passwordD = password else
         {
             return
         }
         print(emailAddress)
         print(passwordD)
         print(!isValidPassword(strPassword: password!))
         if !emailAddress.isValidateEmail()
         {
             let str = LocalisationManager.localisedString("inavlid_email")
             delegate?.sendResponse(handleString: str, emailOrPassword: 0)
         }

//         else if !isValidPassword(strPassword: password!)
//        {
//             let str = LocalisationManager.localisedString("enter_valid_pass_error")
//
//            delegate?.sendResponse(handleString:  str, emailOrPassword: 1)
//        }
        
         else
         {
             loginAPICALL(email :emailAddress, password : passwordD , token: token! ,  controller : controller)
         }
     }
    
    
    func loginAPICALL(email :String, password : String ,  token : String ,  controller : UIViewController)
    {
     let lang = LocalData.getLanguage(LocalData.language)

        let param =
        ["email": email , "password":password, "fcm_token" : token , "device_type" : "0" , "lang" : lang ]
        print(param)
        APIManager.shared.requestService(withURL: Constant.loginAPI, method: .post, param: param , viewController: controller) { [self] (json) in
         print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data =   getDataFrom(JSON: json)
 let model = try JSONDecoder().decode(LoginModel.self, from: data!)
                                   self.delegate?.sendJSONResponse(model: model )
                }
                catch {
                    print("exception")
                }
            }
            else if("\(json["status"])" == "2")
            {
                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }

            else
            {
                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }

        }
    }
    func getDataFrom(JSON json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
    
 }

protocol LoginResponseDelegate
{
    func sendResponse(handleString : String , emailOrPassword : Int)
    func sendFailure(handleString : String)
    func sendJSONResponse(model : LoginModel)
   
}

protocol LoginProtocol
{
    func sendValues(email : String? , password : String? , token : String? , controller : UIViewController)
}
