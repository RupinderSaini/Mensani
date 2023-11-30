//
//  ChangePasswordController.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import UIKit
import Alamofire


class ChangePasswordController: UIViewController {
    
    @IBOutlet weak var txtConfirm: UILabel!
    @IBOutlet weak var txtNew: UILabel!
    @IBOutlet weak var txtOld: UILabel!
    @IBOutlet weak var txtChange: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btnChange(_ sender: Any) {
        forgotValueReset()
    }
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var vCPassword: UIView!
    @IBOutlet weak var vNewPassword: UIView!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var imgHide3: UIImageView!
    @IBOutlet weak var edCPassword: UITextField!
    @IBOutlet weak var imgHide2: UIImageView!
    @IBOutlet weak var edNewPassword: UITextField!
    @IBOutlet weak var imgHide: UIImageView!
    @IBOutlet weak var edOldPassword: UITextField!
    
    
    var iconClick = true
    var iconClick2 = true
    var iconClick3 = true
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews()
    {
        
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        btnChange.setTitle(LocalisationManager.localisedString("change_pass"), for: .normal)
        txtChange.text = LocalisationManager.localisedString("change_pass")
        txtConfirm.text = LocalisationManager.localisedString("confirm_new_pass")
        txtNew.text = LocalisationManager.localisedString("new_pass")
        txtOld.text = LocalisationManager.localisedString("old_pass")
        
        
        setupToHideKeyboardOnTapOnView()
        vCPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        vNewPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        vPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        
        imgHide.isUserInteractionEnabled = true
        imgHide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction)))
        
        imgHide2.isUserInteractionEnabled = true
        imgHide2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction2)))
        
        imgHide3.isUserInteractionEnabled = true
        imgHide3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction3)))
    }
    
    @objc func iconAction3() {
        if(iconClick3 == true) {
            edCPassword.isSecureTextEntry = false
            imgHide3.image = UIImage(systemName: "eye.fill")
        } else {
            edCPassword.isSecureTextEntry = true
            imgHide3.image = UIImage(systemName: "eye.slash.fill")
        }
        iconClick3 = !iconClick3
    }
    
    @objc func iconAction() {
        if(iconClick == true) {
            edOldPassword.isSecureTextEntry = false
            imgHide.image = UIImage(systemName: "eye.fill")
        } else {
            edOldPassword.isSecureTextEntry = true
            imgHide.image = UIImage(systemName: "eye.slash.fill")
        }
        iconClick = !iconClick
    }
    
    @objc func iconAction2() {
        if(iconClick2 == true) {
            edNewPassword.isSecureTextEntry = false
            imgHide2.image = UIImage(systemName: "eye.fill")
        } else {
            edNewPassword.isSecureTextEntry = true
            imgHide2.image = UIImage(systemName: "eye.slash.fill")
        }
        iconClick2 = !iconClick2
    }
    
    func forgotValueReset()
    {
        
        if(currentReachabilityStatus != .notReachable)
        {
            let strPassword = edNewPassword.text!
            let strCPassword = edCPassword.text!
            let strOPassword = edOldPassword.text!
            
            if let text2 = edOldPassword.text?.trimmingCharacters(in: .whitespaces), text2.isEmpty {
                alertFailure(title: LocalisationManager.localisedString("old_pass"), Message: LocalisationManager.localisedString("enter_old_pass_error"))
            }
            
//            else if let text2 = edOldPassword.text, text2.count<7 {
//                alertFailure(title: LocalisationManager.localisedString("old_pass"), Message: LocalisationManager.localisedString("enter_old_pass_error"))
//            }
            
            else if let text = edNewPassword.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
            {
                alertFailure(title: LocalisationManager.localisedString("new_pass"), Message: LocalisationManager.localisedString("enter_new_pass_error"))
            }
           
            else if !isValidPassword(strPassword: edNewPassword.text!)
            {
                alertFailure(title: LocalisationManager.localisedString("new_pass"), Message: LocalisationManager.localisedString("enter_valid_pass_error"))
            }
//
//            else if let text = edCPassword.text?.trimmingCharacters(in: .whitespaces), text.isEmpty
//            {
//                alertFailure(title: LocalisationManager.localisedString("old_pass"), Message: LocalisationManager.localisedString("old_pass"))
//            }
           
            else if (strPassword != strCPassword)
            {
                alertFailure(title: LocalisationManager.localisedString("confirm_new_pass"), Message: LocalisationManager.localisedString("equal_cpass_error"))
            }
            
            else{
                btnChange.isEnabled = false
                resetAPICall(old: strOPassword, new: strCPassword)
            }
        }
        else
        {
            alertInternet()
        }
    }
    
    func resetAPICall(old : String, new : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        let lang = LocalData.getLanguage(LocalData.language)
        let strAPIToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let parameters = ["old_password": old, "new_password": new , "lang" : lang]
        
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.chnagePasswordAPI, method: .post, param: parameters, header: header, viewController: self) { (json) in
         print(json)
            
            
            if("\(json["status"])" == "1")
            {
                self.btnChange.isEnabled = true
                self.alertSucces(title: LocalisationManager.localisedString("change_pass") , Message:  "\(json["message"])")
                
            }
            else
            {
               
                self.btnChange.isEnabled = true
                self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
            }
           
        }
    }
}
