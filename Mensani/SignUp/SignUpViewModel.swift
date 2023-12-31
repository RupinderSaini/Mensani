//
//  SignUpViewModel.swift
//  Mensani
//
//  Created by apple on 12/05/23.
//

import Foundation
import SwiftyJSON
import FirebaseMessaging


class SignUpViewModel : SignUpProtocol
{
    var strDeviceToken = ""
    var delegate: SignupValidationDelegate?
    var delegate2: LoginResponseDelegate?
    
    
    func sendValues(name: String?, email: String?, password: String?, cpassword: String?, token : String?,sportsId : String? , teamId : String?, controller: UIViewController) {
        guard let namee = name else
        {
            return
        }
        guard let emailAddress = email else
        {
            return
        }
        guard let passwordD = password else
        {
            return
        }
        guard let cpasswordD = cpassword else
        {
            return
        }
        guard let team = teamId else
        {
            return
        }
        guard let sports = sportsId else
        {
            return
        }
        
        checkValidation(name: namee, email: emailAddress, password: passwordD, cpassword: cpasswordD, token : token! ,sports: sports, team: team, controller : controller)
        
    }
    
    
    func checkValidation(name: String, email: String, password: String, cpassword: String ,token : String,sports : String , team : String , controller : UIViewController)
    {
        print("validation")
        if  name.count < 1
        {
            delegate?.sendResponse(handleString: LocalisationManager.localisedString("enter_name_error"), emailOrPassword: 2)
        }
      else  if !email.isValidateEmail()
        {
            delegate?.sendResponse(handleString: LocalisationManager.localisedString("enter_email_error"), emailOrPassword: 0)
        }

       else if password.count<8
       {
           delegate?.sendResponse(handleString:  LocalisationManager.localisedString("enter_valid_pass_error"), emailOrPassword: 1)
       }
        else if !isValidPassword(strPassword: password)
       {
           delegate?.sendResponse(handleString:  LocalisationManager.localisedString("enter_valid_pass_error"), emailOrPassword: 1)
       }
     
        else if (password != cpassword)
        {
            delegate?.sendResponse(handleString:  LocalisationManager.localisedString("equal_cpass_error"), emailOrPassword: 3)
        }
        else if sports == ""
        {
            delegate?.sendResponse(handleString:  LocalisationManager.localisedString("select_sports"), emailOrPassword: 4)
        }
        else if team == ""
        {
            delegate?.sendResponse(handleString:  LocalisationManager.localisedString("team"), emailOrPassword: 5)
        }
        else
        {
            otpAPICALL(email :email, controller : controller)
//            loginAPICALL(email :email, password : password , name : name ,token : token,sportsId: sports, teamId: team ,controller : controller)
        }
    }
   
    func otpAPICALL(email :String, controller : UIViewController)
    {
        let lang = LocalData.getLanguage(LocalData.language)


        let param =
        ["email": email  , "lang" : lang]
        print(param)
        APIManager.shared.requestService(withURL: Constant.otpSignUpAPI, method: .post, param: param , viewController: controller) { [self] (json) in
         print(json)

            if("\(json["status"])" == "1")
            {
                                    self.delegate?.sendJSONResponse(model: json )
              
            }
           

            else
            {
//                self.delegate2?.sendFailure(handleString:  "\(json["message"])")
                controller.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
            }

        }
    }
    func loginAPICALL(email :String, password : String , name : String, token : String,sportsId : String? , teamId : String?, controller : UIViewController)
    {
//        self.btnLogin.isEnabled = true
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            self.strDeviceToken = "\(token)"
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        let param =
        ["email": email , "password":password, "name" : name, "fcm_token" : token , "device_type" : "0"]
        print(param)
        APIManager.shared.requestService(withURL: Constant.signUpAPI, method: .post, param: param , viewController: controller) { [self] (json) in
         print(json)

            if("\(json["status"])" == "1")
            {
                
      self.delegate?.sendJSONResponse(model: json )
               
            }
           

            else
            {
//                self.delegate2?.sendFailure(handleString:  "\(json["message"])")
                controller.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
            }

        }
    }
    
    
   
    
 }

protocol SignupValidationDelegate
{
    func sendResponse(handleString : String , emailOrPassword : Int)
    func sendJSONResponse(model : JSON)
}

protocol SignUpProtocol
{
    func sendValues(name: String?, email: String?, password: String?, cpassword: String?, token : String?,sportsId : String? , teamId : String?, controller : UIViewController)
}
