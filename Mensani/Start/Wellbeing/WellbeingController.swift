//
//  WellbeingController.swift
//  Mensani
//
//  Created by apple on 27/06/23.
//

import UIKit
import Alamofire


class WellbeingController: UIViewController {
    var arrOfButton : [UIButton] = []
    var lastSelectedButton : UIButton!
    @IBOutlet weak var btnExcited: UIButton!
   
    @IBOutlet weak var btnSad: UIButton!
    @IBOutlet weak var btnBored: UIButton!
    @IBOutlet weak var btnCalm: UIButton!
    @IBOutlet weak var btnFocused: UIButton!
    @IBOutlet weak var btnHappy: UIButton!
    @IBOutlet weak var btnAnnyoed: UIButton!
    @IBOutlet weak var btnAngry: UIButton!
    @IBOutlet weak var btnWoried: UIButton!
    @IBOutlet weak var btnDepressed: UIButton!
    
    @IBOutlet weak var txtWell: UILabel!
    @IBOutlet weak var txtMyTho: UILabel!
    @IBOutlet weak var txtIFeel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAnxious: UIButton!
    @IBAction func btnExicted(_ sender: Any) {
        print("clicked")
       changeBackground(btn: btnExcited)
        lastSelectedButton = btnExcited
    }
    
    @IBAction func btnHappy(_ sender: Any) {
        changeBackground(btn: btnHappy)
        lastSelectedButton = btnHappy
    }
    
    @IBAction func btnFocused(_ sender: Any) {
        changeBackground(btn: btnFocused)
        lastSelectedButton = btnFocused
    }
    
    @IBAction func btnBored(_ sender: Any) {
        changeBackground(btn: btnBored)
        lastSelectedButton = btnBored
    }
    
    @IBAction func btnAngry(_ sender: Any) {
        changeBackground(btn: btnAngry)
        lastSelectedButton = btnAngry
        
    }
    @IBAction func btnAnnnoyed(_ sender: Any) {
        changeBackground(btn: btnAnnyoed)
        lastSelectedButton = btnAnnyoed
    }
    @IBAction func btnDepressed(_ sender: Any) {
        changeBackground(btn: btnDepressed)
        lastSelectedButton = btnDepressed
    }
    @IBAction func btnSad(_ sender: Any) {
        changeBackground(btn: btnSad)
        lastSelectedButton = btnSad
    }
    @IBAction func btnCalm(_ sender: Any) {
        changeBackground(btn: btnCalm)
        lastSelectedButton = btnCalm
    }
    
    @IBAction func btnWorried(_ sender: Any) {
        changeBackground(btn: btnWoried)
        lastSelectedButton = btnWoried
    }
    @IBAction func btnAnxious(_ sender: Any) {
        changeBackground(btn: btnAnxious)
        lastSelectedButton = btnAnxious
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            
            var  strThought = edThoughts.text.trimmingCharacters(in: .whitespaces)
            
            if lastSelectedButton != nil{
                var strMood = lastSelectedButton.titleLabel?.text
                addAPICALL(mood: strMood!, thought: strThought)
            }
            else
            {
                alertFailure(title:LocalisationManager.localisedString("well_being") , Message: LocalisationManager.localisedString("select_mood"))
            }
        }
        else
        {
            alertInternet()
        }
    }
    
    @IBOutlet weak var btnSave: UIButton!
    @IBAction func btnback(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var edThoughts: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()
        setupToHideKeyboardOnTapOnView()
        arrOfButton.append(btnExcited)
        arrOfButton.append(btnDepressed)
        arrOfButton.append(btnWoried)
        arrOfButton.append(btnAngry)
        arrOfButton.append(btnAnxious)
        arrOfButton.append(btnAnnyoed)
        arrOfButton.append(btnSad)
        arrOfButton.append(btnCalm)
        arrOfButton.append(btnBored)
        arrOfButton.append(btnHappy)
       setBorder10(viewName: btnSave, radius: 10)
        setBorder10(viewName: edThoughts, radius: 10)
        
        if UserDefaults.standard.string(forKey: Constant.WELLBEING_MOOD) != nil
        {
            let mood = UserDefaults.standard.string(forKey: Constant.WELLBEING_MOOD)
            print(mood!)
            for pos in arrOfButton {
               
                if (pos.titleLabel!.text!.lowercased() == "\(mood!.lowercased())")
                {
                  
                    changeBackground(btn: pos)
                    lastSelectedButton = pos
                }
            }
        }
        
      if UserDefaults.standard.string(forKey: Constant.WELLBEING_THOUGHTS) != nil
        {
        
         let str = UserDefaults.standard.string(forKey: Constant.WELLBEING_THOUGHTS)
         if str!.count<1
         {
            
         }
         else
         {
             if str == "null"
             {
                 edThoughts.text = ""
             }
             else
             {
                 edThoughts.text = str
             }
         }
     }
    
//        self.btnAngry.transform = self.btnAngry.transform.rotated(by: CGFloat.pi)
//
//        self.btnAnnyoed.transform = self.btnAnnyoed.transform.rotated(by: CGFloat.pi/2)
//
//        self.btnWoried.transform = self.btnWoried.transform.rotated(by: CGFloat(Double.pi/2))
//
//        self.btnAnxious.transform = self.btnAnxious.transform.rotated(by: CGFloat(Double.pi/2))
        
        viewBottom(viewBtn: btnExcited)
//        viewBottom(viewBtn: btnAngry)
//        viewBottom(viewBtn: btnWoried)
        
        btnAnxious.layer.cornerRadius = 10
        btnAnxious.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnAnxious.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnAnxious.layer.borderWidth = 0.5
        
        btnWoried.layer.cornerRadius = 10
        btnWoried.layer.maskedCorners = [.layerMinXMinYCorner]
        btnWoried.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnWoried.layer.borderWidth = 0.5
        
        btnDepressed.layer.cornerRadius = 10
        btnDepressed.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        btnDepressed.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnDepressed.layer.borderWidth = 0.5
        
        btnAnnyoed.layer.cornerRadius = 10
        btnAnnyoed.layer.maskedCorners = [.layerMinXMaxYCorner]
        btnAnnyoed.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnAnnyoed.layer.borderWidth = 0.5
        
        txtWell.lineBreakMode = .byCharWrapping
        
        btnAngry.layer.cornerRadius = 10
        btnAngry.layer.maskedCorners = [.layerMaxXMinYCorner]
        btnAngry.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnAngry.layer.borderWidth = 0.5
        
        btnAnxious.layer.cornerRadius = 10
        btnAnxious.layer.maskedCorners = [.layerMaxXMaxYCorner]
        btnAnxious.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnAnxious.layer.borderWidth = 0.5

//        btnAngry.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
////        btnAnnyoed.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        btnAnnyoed.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        btnWoried.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
//        btnAnnyoed.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2 )
       
    }
    
    func setLanguage()
    {
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        
        btnSad.setTitle(LocalisationManager.localisedString("sad"), for: .normal)
        btnCalm.setTitle(LocalisationManager.localisedString("calm"), for: .normal)
    
        btnAngry.setTitle(LocalisationManager.localisedString("angry"), for: .normal)
        btnBored.setTitle(LocalisationManager.localisedString("bored"), for: .normal)
        btnWoried.setTitle(LocalisationManager.localisedString("worried"), for: .normal)
        btnAnxious.setTitle(LocalisationManager.localisedString("anxious"), for: .normal)
        btnAnnyoed.setTitle(LocalisationManager.localisedString("annyoed"), for: .normal)
        btnDepressed.setTitle(LocalisationManager.localisedString("depressed"), for: .normal)
        btnExcited.setTitle(LocalisationManager.localisedString("Excited"), for: .normal)
        btnFocused.setTitle(LocalisationManager.localisedString("focused"), for: .normal)
        btnHappy.setTitle(LocalisationManager.localisedString("happy"), for: .normal)
        txtIFeel.text = LocalisationManager.localisedString("i_feel")
        txtMyTho.text = LocalisationManager.localisedString("my_thots")
        txtWell.text = LocalisationManager.localisedString("well_being")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtMyTho.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtIFeel.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        edThoughts.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        edThoughts.tintColor = .white
//        txtWell.textColor = hexStringToUIColor(hex: color ?? "#fff456")
    }
    
    
    func changeBackground(btn : UIButton)
    {
        btn.layer.borderWidth = 4
        btn.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        if lastSelectedButton != nil
        {
            lastSelectedButton.layer.borderWidth = 0
            
        }
        
    }
    
    func addAPICALL(mood : String , thought : String )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["mood": mood.description , "thought" : thought.description , "lang" : lang]
 
      
        APIManager.shared.requestService(withURL: Constant.wellbeingAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                    //                let data =   getDataFrom(JSON: json)
//                    let datat =  try json.rawData(options: .prettyPrinted)
                   UserDefaults.standard.set(mood.description, forKey: Constant.WELLBEING_MOOD)
                   UserDefaults.standard.set(thought.description, forKey: Constant.WELLBEING_THOUGHTS)
              
                self.alertSucces(title: LocalisationManager.localisedString("save_success"), Message: "\(json["message"])")
            }
           
            else
            {
                self.alertFailure(title: LocalisationManager.localisedString("failed"), Message: "\(json["message"])")
            }
            
        }
        
    }

}
