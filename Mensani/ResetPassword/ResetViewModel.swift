//
//  ResetViewModel.swift
//  Mensani
//
//  Created by apple on 15/05/23.
//

import Foundation
import SwiftyJSON


class ResetViewModel : ResetProtocol
{
   
    var delegate: ResetValidationDelegate?
  
    func sendValues(email: String?, password : String?, emaill : String?,controller : UIViewController) {
     
        guard let passwordd = email else
        {
            return
        }
        guard let emailAddress = emaill else
        {
            return
        }
        guard let cpassword = password else
        {
            return
        }
        
        if !isValidPassword(strPassword: passwordd)
        {
            delegate?.sendResponse(handleString:  LocalisationManager.localisedString("enter_valid_pass_error"), passwordOrC: 0)
        }
       
         else if (passwordd != cpassword)
         {
             delegate?.sendResponse(handleString:  LocalisationManager.localisedString("equal_cpass_error"), passwordOrC: 1)
         }
        else
        {
            resetAPICALL(email: emailAddress, cPassword: cpassword, controller: controller)
        }
    }
    
    
    func resetAPICALL(email :String, cPassword : String, controller : UIViewController)
    {
        let lang = LocalData.getLanguage(LocalData.language)

        let param =
        ["email": email , "password" : cPassword, "lang" : lang]
        APIManager.shared.requestService(withURL: Constant.resetPasswordAPI, method: .post, param: param , viewController: controller) {  (json) in
         print(json)
            if("\(json["status"])" == "1")
            {
                self.delegate?.sendJSONResponse(model: json )
            }
            else if("\(json["status"])" == "2")
            {
                controller.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            else
            {
                controller.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
        }
    }
}

protocol ResetProtocol
{
    func sendValues(email : String? , password : String? ,  emaill : String? , controller : UIViewController)
}

protocol ResetValidationDelegate
{
    func sendResponse(handleString : String , passwordOrC : Int)
    func sendJSONResponse(model : JSON)
    
}
