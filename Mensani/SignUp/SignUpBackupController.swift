//
//  SignUpBackupController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 07/02/24.
//

import UIKit
import FirebaseMessaging
import DropDown
import Alamofire
import SwiftyJSON

class SignUpBackupController: UIViewController , UITextFieldDelegate , SignupValidationDelegate , sportsDelegate{
    
    func selectedSportId(sports: String, id: String) {
        print(sports)
        print(id)
        setYellow(string: LocalisationManager.localisedString("sports"), textField: txtSports)
        btnSports.setTitle(sports, for: .normal)
        sportsID = sports
        sportIDTeam = id
        teamAPICall()
    }
    
    @IBOutlet weak var edToken: UITextField!
  
    func sendJSONResponse(model: JSON) {
        let otp = "\(model["otp"])"
        print(otp)
        let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "otp") as! OTPController
        pushControllerObj.strEmail = edEmail.text!.description
        pushControllerObj.name = edName.text!.description
        pushControllerObj.password = edPassword.text!.description
        pushControllerObj.sports = sportsID
        pushControllerObj.team = teamID
        pushControllerObj.token = fcmToken
        pushControllerObj.screenType = 0
        pushControllerObj.strOTP = otp
//        pushControllerObj.teamType = strOption
        pushControllerObj.teamToken = edToken.text!.description
        self.navigationController?.pushViewController(pushControllerObj, animated: true)
//        UserDefaults.standard.set("Bearer " + model.data.token, forKey: Constant.API_TOKEN)
//        UserDefaults.standard.set("1", forKey: Constant.IS_LOGGEDIN)
//        performSegue(withIdentifier: "home", sender: nil)
    }
    
    func sendResponse(handleString: String, emailOrPassword: Int) {
        switch emailOrPassword {
        case 0:
            setRed(string: handleString, textField: txtEmail)
        case 1:
            setRed(string: handleString, textField: txtPassword)
        case 2:
            setRed(string: handleString, textField: txtName)
        case 3:
            setRed(string: handleString, textField: txtCPassword)
        case 4:
            setRed(string: handleString, textField: txtSports)
        case 5:
            setRed(string: handleString, textField: txtTeam)
        default:
            setRed(string: handleString, textField: txtName)
        }
    }
    
    var iconClick = true
    var iconClick1 = true
    var fcmToken = ""
    var picker = UIPickerView()
    var signUpModel = SignUpViewModel()
    
    @IBAction func btnSignUp(_ sender: Any) {
        loginValue()
    }
   
    @IBOutlet weak var btnPublic: UIButton!
    @IBAction func btnPublic(_ sender: Any) {
        if(strOption == 1)
        {
            self.btnPrivate.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.btnPublic.setBackgroundImage(UIImage(systemName: "record.circle"), for: UIControl.State.normal)
            strOption = 0
            txtTeam.isHidden = false
            btnTeam.isHidden = false
            btnSports.isHidden = false
            edToken.isHidden = true
            txtSports.text = LocalisationManager.localisedString("sports")
            txtTeam.text = LocalisationManager.localisedString("teams")
        }
    }
//    @IBOutlet weak var edToken: UITextField!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBAction func btnPrivate(_ sender: Any) {
        if(strOption == 0)
        {
            self.btnPublic.setBackgroundImage(UIImage(systemName: "poweroff"), for: UIControl.State.normal)
            self.btnPrivate.setBackgroundImage(UIImage(systemName: "record.circle"), for: UIControl.State.normal)
            strOption = 1
            txtSports.text = LocalisationManager.localisedString("token")
            txtTeam.text = LocalisationManager.localisedString("token_explain")
            btnTeam.isHidden = true
            btnSports.isHidden = true
            edToken.isHidden = false
            
        }
       
    }
    @IBOutlet weak var txtPrivate: UILabel!
    @IBOutlet weak var txtPublic: UILabel!
    @IBOutlet weak var txtTeamType: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var edName: UITextField!
    
    @IBOutlet weak var btnTeam: UIButton!
    @IBOutlet weak var btnSports: UIButton!
    @IBOutlet weak var txtTeam: UILabel!
    @IBOutlet weak var txtSports: UILabel!
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var txtCPassword: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgHide2: UIImageView!
    @IBOutlet weak var imgHide: UIImageView!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var vCPassword: UIView!
    @IBOutlet weak var edCPassword: UITextField!
    @IBOutlet weak var edPassword: UITextField!
    @IBOutlet weak var edEmail: UITextField!
    
    @IBOutlet weak var txtLanguage: UITextField!
    @IBOutlet weak var txtLang: UILabel!
  
    @IBAction func bSports(_ sender: Any) {
        let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "sports") as! SportsController
        pushControllerObj.delegate = self
        self.navigationController?.pushViewController(pushControllerObj, animated: true)
    }
    
    @IBAction func bTeam(_ sender: Any) {
        dropDown2.show()
    }
    var sportsID = ""
    var sportIDTeam = ""
    var teamID = ""
    var strOption = 0
    var arrOfTeam : [DatumTeams] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        edToken.isHidden = true
        setupToHideKeyboardOnTapOnView()
        signUpModel.delegate = self
        edEmail.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        vPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        vCPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        edName.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        txtLanguage.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        btnTeam.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        btnSports.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        edToken.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.2)
        
        self.edName.tag = 0
        self.edEmail.tag = 1
        self.edPassword.tag = 2
        self.edCPassword.tag = 3
    
        self.edName.delegate = self
        self.edEmail.delegate = self
        self.edPassword.delegate = self
        self.edCPassword.delegate = self
        self.edToken.delegate = self
     
        imgHide.isUserInteractionEnabled = true
        imgHide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction)))
        
        imgHide2.isUserInteractionEnabled = true
        imgHide2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.iconAction1)))
        
        edEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
     
        edPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        edName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
     
        edCPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        edToken.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            Messaging.messaging().token { token, error in
              if let error = error {
                print("Error fetching FCM registration token: \(error)")
              } else if let token = token {
                print("FCM registration token: \(token)")
                  self.fcmToken = "\(token)"
    //            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
              }
            }
        setupPicker()
        setLanguage()
        teamAPICall()
        dropDownTeam()
    }
    
    func setLanguage()
    {
        txtLanguage.tintColor = .black
        txtSports.text = LocalisationManager.localisedString("sports")
        txtTeam.text = LocalisationManager.localisedString("teams")
        txtName.text = LocalisationManager.localisedString("name")
        txtEmail.text = LocalisationManager.localisedString("Email")
        txtLang.text = LocalisationManager.localisedString("choose_language")
        txtPassword.text = LocalisationManager.localisedString("Password")
        txtCPassword.text = LocalisationManager.localisedString("confirm_password")
        btnSignUp.setTitle(LocalisationManager.localisedString("sign_up"), for: .normal)
        btnSports.setTitle(LocalisationManager.localisedString("select_sports"), for: .normal)
        btnTeam.setTitle(LocalisationManager.localisedString("team"), for: .normal)
//        btnForgot.setTitle(LocalisationManager.localisedString("forget?"), for: .normal)
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

    @objc func iconAction1() {
          if(iconClick == true) {
              edCPassword.isSecureTextEntry = false
              imgHide2.image = UIImage(systemName: "eye.fill")
          } else {
              edCPassword.isSecureTextEntry = true
              imgHide2.image = UIImage(systemName: "eye.slash.fill")
          }

          iconClick = !iconClick
      }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case edName:
            setYellow(string: LocalisationManager.localisedString("name"), textField: txtName)
        case edEmail:
            setYellow(string: LocalisationManager.localisedString("Email"), textField: txtEmail)
        case edPassword:
            setYellow(string: LocalisationManager.localisedString("Password"), textField: txtPassword)
        case edCPassword:
            setYellow(string: LocalisationManager.localisedString("confirm_password"), textField: txtCPassword)
        case edToken:
            setYellow(string: LocalisationManager.localisedString("token"), textField: txtSports)
        default:
            setYellow(string: StringConstant.CONFIRM_PASSWORD_HEADING, textField: txtCPassword)
        }
    }
    
   
    func loginValue()
    {
        if(currentReachabilityStatus != .notReachable)
        {
            if strOption == 0
            {
//                signUpModel.sendValues(name: edName.text?.trimmingCharacters(in: .whitespaces), email:edEmail.text?.trimmingCharacters(in: .whitespaces), password: edPassword.text?.trimmingCharacters(in: .whitespaces), cpassword: edCPassword.text?.trimmingCharacters(in: .whitespaces), token: fcmToken,sportsId: sportsID, teamId: teamID,type: 0 , controller: self)
            }
            else
            {
//                signUpModel.sendValues(name: edName.text?.trimmingCharacters(in: .whitespaces), email:edEmail.text?.trimmingCharacters(in: .whitespaces), password: edPassword.text?.trimmingCharacters(in: .whitespaces), cpassword: edCPassword.text?.trimmingCharacters(in: .whitespaces), token: fcmToken,sportsId: edToken.text?.trimmingCharacters(in: .whitespaces), teamId: "", type : 1 , controller: self)
            }
        }
            else{
               alertInternet()
            }
           // loginAPICall(email: strPhoneNumber!, password: strPassword)
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
    let dropDown = DropDown()
    let dropDown2 = DropDown()
   
    func dropDownTeam()
    {
        dropDown2.anchorView = btnTeam
        dropDown2.direction = .any
    
        dropDown2.layer.cornerRadius = 10
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            btnTeam.setTitle("\(item)", for: .normal)
            teamID = "\(item)"
            setYellow(string: LocalisationManager.localisedString("teams"), textField: txtTeam)
            
//            education = "\(item)"
//            dropDown.dismissMode = .onTap
           
        }
    }
    
    func teamAPICall()
    {
        let param = ["sport_id" : sportIDTeam]
        AF.request(Constant.baseURL + Constant.teamAPI, method: .post, parameters: param ,encoding: JSONEncoding.default)
            .responseJSON { response in
            
                switch response.result {
                    
                case .success(let json):
                    print(json)
                    
                    DispatchQueue.main.async {
                        
                        do
                        {
                            let model = try JSONDecoder().decode(TeamsResponse.self, from: response.data!)
                            self.arrOfTeam = model.data
                            var arrOfName : [String] = []
                            for name in self.arrOfTeam
                            {
                                arrOfName.append(name.teamName)
                            }
                            self.dropDown2.dataSource = arrOfName
                        }
                        catch {
                            print("exception")
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }

        

 }
    

extension SignUpBackupController : UIPickerViewDelegate,UIPickerViewDataSource {
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
        self.setLanguage(language.1)
    }
}



