//
//  ResetViewModel.swift
//  Mensani
//
//  Created by apple on 15/05/23.
//

import Foundation
import SwiftyJSON

class OTPViewModel : OTPProtocol
{
   
    var delegate: OTPValidationDelegate?
    func sendValues(email: String?, controller : UIViewController) {
     
        guard let emailAddress = email else
        {
            return
        }
        if emailAddress.isEmpty
          {
              delegate?.sendResponse(handleString: LocalisationManager.localisedString("enter_otp_error"))
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
        ["otp": email , "device_type" : "0" , "lang" : lang]
        APIManager.shared.requestService(withURL: Constant.verifyOTPAPI, method: .post, param: param , viewController: controller) {  (json) in
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

protocol OTPProtocol
{
    func sendValues(email : String? , controller : UIViewController)
}

protocol OTPValidationDelegate
{
    func sendResponse(handleString : String)
    func sendJSONResponse(model : JSON)
    
}
