//
//  ProfileController.swift
//  Mensani
//
//  Created by apple on 16/05/23.
//

import UIKit
import Alamofire

class ProfileController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var txtLanguage: UILabel!
    @IBOutlet weak var vLanguage: UIView!
    @IBOutlet weak var txtJoined: UILabel!
    @IBOutlet weak var vDelete: UIView!
    @IBOutlet weak var VAppoint: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtJoinedTime: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var vProfile: UIView!
    @IBOutlet weak var vPrivacy: UIView!
    @IBOutlet weak var vSettings: UIView!
    
    @IBOutlet weak var vLogout: UIView!
    @IBOutlet weak var vUpgrade: UIView!
    @IBOutlet weak var stackBtn: UIStackView!
    
    @IBOutlet weak var btnSupport: UIButton!
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSeason: UIButton!
    @IBAction func btnSeason(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "season") as? SeasonController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func btnStart(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start") as? StartController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnSupport(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "support") as? SupportController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //    @IBOutlet weak var btnPro: UIButton!
    @IBOutlet weak var viewBtn: UIView!
    
    @IBOutlet weak var txtEditProfile: UILabel!
    
    @IBOutlet weak var txtDelete: UILabel!
    @IBOutlet weak var txtPriv: UILabel!
    
    @IBOutlet weak var txtLogout: UILabel!
    @IBOutlet weak var txtAppointmnet: UILabel!
    @IBOutlet weak var txtSettings: UILabel!
    @IBOutlet weak var txtSubs: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews()
    {
//       
        setBorder10(viewName: btnStart, radius: 15)
        setBorder10(viewName: btnSeason, radius: 15)
        setBorder10(viewName: btnSupport, radius: 15)
        stackBtn.layer.cornerRadius=20
        stackBtn.clipsToBounds=true
        viewBottom(viewBtn: viewBtn)
        
        //        btnPro.layer.cornerRadius=8
        //        btnPro.clipsToBounds=true
        //        btnPro.layer.borderWidth = 0.5
        //        btnPro.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //        vUpgrade.layer.cornerRadius = 10
        ////        vUpgrade.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        //        vUpgrade.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        vUpgrade.layer.borderWidth = 0.5
        
        vUpgrade.isUserInteractionEnabled = true
        vUpgrade.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.upgradeCall)))
        
        vLanguage.isUserInteractionEnabled = true
        vLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.languageCall)))
        //
        vProfile.isUserInteractionEnabled = true
        vProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileCall)))
        
        vSettings.isUserInteractionEnabled = true
        vSettings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.settingsCall)))
        
        vLogout.isUserInteractionEnabled = true
        vLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logoutCall)))
        //
        vPrivacy.isUserInteractionEnabled = true
        vPrivacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.privacyCall)))
        
        VAppoint.isUserInteractionEnabled = true
        VAppoint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.appointCall)))
        
        vDelete.isUserInteractionEnabled = true
        vDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.deleteCall)))
        
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        
        setLanguage()
    }
    
    func setLanguage()
    {
        txtLanguage.text =  LocalisationManager.localisedString("language")
        txtJoined.text =  LocalisationManager.localisedString("joined")
        txtEditProfile.text =  LocalisationManager.localisedString("edit_pro")
        txtPriv.text =  LocalisationManager.localisedString("privacy_policy")
        txtSettings.text =  LocalisationManager.localisedString("settings")
        txtAppointmnet.text =  LocalisationManager.localisedString("appointments")
        //        txtUpgrade.text =  LocalisationManager.localisedString("upgrade")
        txtLogout.text =  LocalisationManager.localisedString("logout")
        txtSubs.text =  LocalisationManager.localisedString("subscription")
        txtDelete.text =  LocalisationManager.localisedString("del_account")
        //        txtDelete.text =  LocalisationManager.localisedString("del_account")
        btnStart.setTitle(LocalisationManager.localisedString("event"), for: .normal)
        btnSeason.setTitle(LocalisationManager.localisedString("season"), for: .normal)
        btnSupport.setTitle(LocalisationManager.localisedString("support"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set profile data
        setData()
    }
    
    func setData()
    {
        txtName.text = UserDefaults.standard.string(forKey: Constant.NAME)
        txtJoinedTime.text = UserDefaults.standard.string(forKey: Constant.TIME_JOINED)
        //        .text = UserDefaults.standard.string(forKey: Constant.NAME)
        //        txtName.text = UserDefaults.standard.string(forKey: Constant.NAME)
        
        if UserDefaults.standard.string(forKey: Constant.IMAGE) != nil
        {
            let strImageURL =
            UserDefaults.standard.string(forKey: Constant.IMAGE)!
            if(strImageURL.count>2)
            {
                let urlYourURL = URL (string:strImageURL )
                imgProfile.loadurl(url: urlYourURL!)
                
            }
        }
    }
    @objc func logoutCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                alertUILogged()
            }
        }else{
            alertInternet()
        }
    }
    
    
    @objc func privacyCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "web") as? WebViewController
            vc?.callFrom = 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
        
    }
    
    @objc func languageCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "langu") as? LanguageController
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
        
    }
    
    @objc func appointCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "book") as? AppointListController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
        
    }
    
    @objc func deleteCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            alertUIDelete()
        }else{
            alertInternet()
        }
        
    }
    
    @objc func upgradeCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "subsc") as? SubscriptionController
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
        
    }
    
    
    @objc func profileCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                alertUIGuestUser()
            }
            else{
                
                performSegue(withIdentifier: "profile", sender: nil)
            }
        }
        else{
            alertInternet()
        }
    }
    
    @objc func settingsCall() {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            if(UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID) == "2")
            {
                alertUIGuestUser()
            }
            else{
                
                performSegue(withIdentifier: "password", sender: nil)
                
            }
        }
        else{
            alertInternet()
        }
    }
    
    
    func alertUILogged() -> Void
    {
        
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("logout"), message: LocalisationManager.localisedString("logout_txt"), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("no"), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("yes"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.logoutApi()
                UserDefaults.standard.setValue("0", forKey: Constant.IS_LOGGEDIN)
                //
                let domain = Bundle.main.bundleIdentifier!
                //                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
                //                self.tabBarController?.selectedIndex = 0
                //                self.performSegue(withIdentifier: "login", sender: nil)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func alertUIDelete() -> Void
    {
        
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("del_account"), message: LocalisationManager.localisedString("perma_del_acc"), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("no"), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("yes"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.deleteApi()
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func logoutApi()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["athlete_id": apiToken]
        print(param)
        APIManager.shared.requestService(withURL: Constant.deleteAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                
            }
            
            
            else
            {
                //                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
    func deleteApi()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["athlete_id": apiToken]
        print(param)
        APIManager.shared.requestService(withURL: Constant.deleteAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                UserDefaults.standard.setValue("0", forKey: Constant.IS_LOGGEDIN)
                //
                let domain = Bundle.main.bundleIdentifier!
                //                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            
            else
            {
                //                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    //Language
    
}
