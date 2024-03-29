//
//  ForgotController.swift
//  Mensani
//
//  Created by apple on 08/05/23.
//

import UIKit
import SwiftyJSON

class ForgotController: UIViewController , ForgotValidationDelegate , UITextFieldDelegate{
   
    var forgetVM = ForgetViewModel()
    
    func sendResponse(handleString: String) {
        
        setRed(string: handleString, textField: txtEmail)
    }
    
    func sendJSONResponse(model: JSON) {
        performSegue(withIdentifier: "otp", sender: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEnter: UILabel!
    @IBOutlet weak var txtForgotPassword: UILabel!
    @IBOutlet weak var edEmail: UITextField!
    @IBAction func btnForgot(_ sender: Any) {
        loginValue()
    }
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        txtForgotPassword.text = LocalisationManager.localisedString("forget")
        txtEnter.text = LocalisationManager.localisedString("forget_txt")
        txtEmail.text = LocalisationManager.localisedString("Email")
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnForgot.setTitle(LocalisationManager.localisedString("next"), for: .normal)
        forgetVM.delegate = self
        edEmail.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        edEmail.delegate = self
        edEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setYellow(string: LocalisationManager.localisedString("Email"), textField: txtEmail)
    }
    
    func loginValue()
    {
        
        if(currentReachabilityStatus != .notReachable)
        {
            
            forgetVM.sendValues(email:edEmail.text?.trimmingCharacters(in: .whitespaces) , controller: self)
        }
        else{
            alertInternet()
        }
        // loginAPICall(email: strPhoneNumber!, password: strPassword)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let secondViewController = segue.destination as! OTPController
        secondViewController.strEmail = edEmail.text!.trimmingCharacters(in: .whitespaces)
        secondViewController.screenType = 1
        
    }
}
