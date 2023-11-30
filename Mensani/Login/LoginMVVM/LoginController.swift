//
//  LoginController.swift
//  Mensani
//
//  Created by apple on 04/05/23.
//

import UIKit
import FirebaseMessaging
import DropDown

class LoginController: UIViewController , UITextFieldDelegate , LoginResponseDelegate {
    
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var imgLogin: UIImageView!
    
    @IBOutlet weak var txtLanguage: UITextField!
    // View Model API response for login
    func sendJSONResponse(model: LoginModel)
    {
//        var currentVCStack = self.navigationController?.viewControllers

        UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
        UserDefaults.standard.set("Bearer " + model.data.token, forKey: Constant.API_TOKEN)
        
        performSegue(withIdentifier: "home", sender: nil)
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "home") as? HomeController
//
//        self.navigationController?.setViewControllers([vc!], animated: true)
    }
    
    func sendFailure(handleString: String) {
        alertFailure(title: StringConstant.FAILED, Message: handleString)
    }
    
    // View Model response for validations
    func sendResponse(handleString: String, emailOrPassword: Int) {
        if emailOrPassword == 0
        {
            setRed(string: handleString, textField: txtEmail)
        }
        else
        {
            setRed(string: handleString, textField: txtPassword)
        }
    }
    
    var iconClick = true
    var loginVM = LoginViewModel()
    let dropDown = DropDown()
    private var viewModel: LoginModel? = nil
   
    @IBOutlet weak var txtLang: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBAction func btnLogin(_ sender: Any) {
        loginVM.sendValues(email: edEmail.text?.trimmingCharacters(in: .whitespaces), password: edPassword.text?.trimmingCharacters(in: .whitespaces) , token: self.fcmToken , controller : self)
    }
    
    @IBAction func btnForgot(_ sender: Any) {
        performSegue(withIdentifier: "forgot", sender: nil)
    }
  
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var imgHide: UIImageView!
    @IBOutlet weak var edPassword: UITextField!
    @IBOutlet weak var edEmail: UITextField!
    
    var fcmToken = ""
    var picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        txtLanguage.tintColor = .black
        txtEmail.text = LocalisationManager.localisedString("Email")
        txtLang.text = LocalisationManager.localisedString("choose_language")
        txtPassword.text = LocalisationManager.localisedString("Password")
        btnLogin.setTitle(LocalisationManager.localisedString("login"), for: .normal)
        btnForgot.setTitle(LocalisationManager.localisedString("forget?"), for: .normal)
      
//        var color1 = hexStringToUIColor(hex: "#9ff3d3")
//        txtEmail.textColor = color1
        loginVM.delegate = self
        setupToHideKeyboardOnTapOnView()
        edEmail.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        vPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtLanguage.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        setupPicker()
        indicator.isHidden = true
        
        self.edEmail.tag = 0
        self.edPassword.tag = 1
    
        self.edEmail.delegate = self
        self.edPassword.delegate = self
        
        imgHide.isUserInteractionEnabled = true
        imgHide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction)))
      
        edEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
     
        edPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
      
        Messaging.messaging().token { token, error in
          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
//            print("FCM registration token: \(token)")
              self.fcmToken = "\(token)"
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        
       
    }
    
    //User start typing, observer to change the heading
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == edEmail
        {
            setYellow(string: LocalisationManager.localisedString("Email"), textField: txtEmail)
        }
        else
        {
            setYellow(string: LocalisationManager.localisedString("Password"), textField: txtPassword)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func iconAction() {
          if(iconClick == true) {
              edPassword.isSecureTextEntry = false
              imgHide.image = UIImage(systemName: "eye.fill")
          } else {
              edPassword.isSecureTextEntry = true
              imgHide.image = UIImage(systemName: "eye.slash.fill")
          }
          iconClick = !iconClick
      }

    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    //Language
     func setupPicker() {
         self.picker.backgroundColor = .white
         self.picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 150))
         self.picker.delegate = self
         self.picker.dataSource = self
         self.setPicerData()
         self.txtLanguage.inputView = self.picker
     }
     func setPicerData() {
         let languageCode = LocalData.getLanguage(LocalData.language)
         if let lang = languages.filter({$0.1 == languageCode}).first {
             self.txtLanguage.text = lang.0
             self.picker.selectRow(lang.1 == "en" ? 0 : 1, inComponent: 0, animated: false)
         }
     }
 }
 extension LoginController : UIPickerViewDelegate,UIPickerViewDataSource {
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return languages.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
         return languages[row].0
     }
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         
         self.txtLanguage.resignFirstResponder()
         let language = languages[row]
         self.txtLanguage.text = language.0
//         print(language.0)
         self.setLanguage(language.1)
         
     }
}


