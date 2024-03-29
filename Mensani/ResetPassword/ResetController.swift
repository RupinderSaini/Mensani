//
//  ResetController.swift
//  Mensani
//
//  Created by apple on 15/05/23.
//

import UIKit
import SwiftyJSON

class ResetController: UIViewController , ResetValidationDelegate, UITextFieldDelegate {
    func sendResponse(handleString: String , passwordOrC : Int) {
        if passwordOrC == 0
        {
            setRed(string: handleString, textField: txtPassword)
        }
        else
        {
            setRed(string: handleString, textField: txtCPassword)
        }
    }
    
    @IBOutlet weak var btnback: UIButton!
    func sendJSONResponse(model: JSON) {
//        self.alertSucces(title: "Success", Message: "Password reset")
        var currentVCStack = self.navigationController?.viewControllers
           currentVCStack?.removeSubrange(2...3)

           let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginsignup")
           currentVCStack?.append(fifthVC)

           self.navigationController?.setViewControllers(currentVCStack!, animated: true)
       
    }
    
    @IBOutlet weak var txtCPassword: UILabel!
    @IBOutlet weak var txtPassword: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReset(_ sender: Any) {
        loginValue()
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var edCPassword: UITextField!
    @IBOutlet weak var edpassword: UITextField!
    
    @IBOutlet weak var txtResetpass: UILabel!
    @IBOutlet weak var txtEnter: UILabel!
    var strEmail = ""
    var resetVM = ResetViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetVM.delegate = self
        setupToHideKeyboardOnTapOnView()
        edpassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        edpassword.delegate = self
        edpassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        edCPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        edCPassword.delegate = self
        edCPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txtPassword.text = LocalisationManager.localisedString("Password")
        txtCPassword.text = LocalisationManager.localisedString("confirm_password")
        txtEnter.text = LocalisationManager.localisedString("enter_new_pass")
        txtResetpass.text = LocalisationManager.localisedString("reset_pass")
        
        
        btnReset.setTitle(LocalisationManager.localisedString("reset"), for: .normal)
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == edpassword
        {
            setYellow(string: LocalisationManager.localisedString("Password"), textField: txtPassword)
        }
        else
        {
            setYellow(string: LocalisationManager.localisedString("confirm_password"), textField: txtCPassword)
        }
    }
   
    
    func loginValue()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            resetVM.sendValues(email:edpassword.text?.trimmingCharacters(in: .whitespaces) , password: edCPassword.text?.trimmingCharacters(in: .whitespaces) , emaill: strEmail , controller: self)
        }
            else{
                alertInternet()
            }
            // loginAPICall(email: strPhoneNumber!, password: strPassword)
        }
    
}
