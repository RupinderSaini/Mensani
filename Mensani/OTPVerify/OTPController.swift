//
//  ResetController.swift
//  Mensani
//
//  Created by apple on 15/05/23.
//

import UIKit
import SwiftyJSON

class OTPController : UIViewController  ,  OTPValidationDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var txtCheckEmail: UILabel!
    @IBOutlet weak var txtVerification: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail: UILabel!
    var resetVM = OTPViewModel()
   
    func sendResponse(handleString: String) {
      setRed(string: handleString, textField: txtOTP)
    }
    
    func sendJSONResponse(model: JSON) {
       performSegue(withIdentifier: "reset", sender: nil)
    }
  
    @IBAction func btnVerify(_ sender: Any) {
        loginValue()
    }
   
    @IBAction func btnBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var txtOTP: UILabel!
    @IBOutlet weak var edOtp: UITextField!
    
    var strEmail = ""
    var screenType = 0
    
    // signupValues
    var name = ""
    var password = ""
    var sports = ""
    var team = ""
    var token = ""
    var strOTP = ""
    var teamToken = ""
    var teamType : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()

        txtEmail.text = strEmail
        print(teamType)
        txtOTP.text = LocalisationManager.localisedString("otp")
        txtVerification.text = LocalisationManager.localisedString("verification")
        txtCheckEmail.text = LocalisationManager.localisedString("otp_txt")
        btnVerify.setTitle(LocalisationManager.localisedString("verify"), for: .normal)
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        
        resetVM.delegate = self
        edOtp.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        edOtp.delegate = self
        edOtp.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        setYellow(string: LocalisationManager.localisedString("otp"), textField: txtOTP)
    }
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (edOtp.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= 5
    }
    
    func loginValue()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            
            if screenType == 0
            {
                let otp = edOtp.text?.trimmingCharacters(in: .whitespaces)
                 if otp != strOTP
                {
                    setRed(string: LocalisationManager.localisedString("enter_otp_error"), textField: txtOTP)
                }
                else
                {
                    signUpAPICALL()
                }
            }
            else
            {
                resetVM.sendValues(email:edOtp.text?.trimmingCharacters(in: .whitespaces) , controller: self)
            }
           
        }
        else{
            alertInternet()
        }
        // loginAPICall(email: strPhoneNumber!, password: strPassword)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! ResetController
        secondViewController.strEmail = strEmail

    }
    
    func signUpAPICALL()
    {
        let lang = LocalData.getLanguage(LocalData.language)
        var param : [String : String]
        print(teamType)
        if teamType!
        {
            param =
            ["email": strEmail , "password":password, "name" : name, "fcm_token" : token , "sport_id" : sports, "team_id" : team,  "device_type" : "0" , "lang" : lang]
          
        }
        else
        {
            param =
            ["email": strEmail , "password":password, "name" : name, "fcm_token" : token ,  "token" : teamToken,  "device_type" : "0" , "lang" : lang]
           
        }
        print(param)
        APIManager.shared.requestService(withURL: Constant.signUpAPI, method: .post, param: param , viewController: self) {  (json) in
         print(json)

            if("\(json["status"])" == "1")
            {
                do {
                    let data =   getDataFrom(JSON: json)
                    let model = try JSONDecoder().decode(LoginModel.self, from: data!)
                    UserDefaults.standard.set("Bearer " + model.data.token, forKey: Constant.API_TOKEN)
                    UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
//                    UserDefaults.standard.set("\(json["data"]["team_color"])", forKey: Constant.TEAMCOLOR)
                    let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "home") as! HomeController
                   
                    self.navigationController?.pushViewController(pushControllerObj, animated: true)
                    
                }
                catch
                {
                    
                }
            }
            else
            {
                
                self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
            }

        }
    }
}
