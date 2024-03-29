//
//  ForgetViewModel.swift
//  Mensani
//
//  Created by apple on 12/05/23.
//

import Foundation
import SwiftyJSON

class ForgetViewModel : ForgotProtocol
{
    var delegate: ForgotValidationDelegate?
    func sendValues(email: String?, controller : UIViewController) {
     
        guard let emailAddress = email else
        {
            return
        }
        if !emailAddress.isValidateEmail()
          {
              delegate?.sendResponse(handleString: LocalisationManager.localisedString("enter_email_error"))
          }
            else
        {
    forgotAPICALL(email: emailAddress, controller: controller )
        }
    }
    
    func forgotAPICALL(email :String,  controller : UIViewController)
    {
        let lang = LocalData.getLanguage(LocalData.language)

        let param =
        ["email": email , "device_type" : "0" , "lang" : lang]
        print(param)
        APIManager.shared.requestService(withURL: Constant.forgotAPI, method: .post, param: param , viewController: controller) {  (json) in
         print(json)
            if("\(json["status"])" == "1")
            {
                self.delegate?.sendJSONResponse(model: json )
            }
            
            else
            {
                controller.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
        }
    }
}

protocol ForgotProtocol
{
    func sendValues(email : String? , controller : UIViewController)
}

protocol ForgotValidationDelegate
{
    func sendResponse(handleString : String)
    func sendJSONResponse(model : JSON)
 
}
