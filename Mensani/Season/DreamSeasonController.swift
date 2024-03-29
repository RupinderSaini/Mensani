//
//  DreamSeasonController.swift
//  Mensani
//
//  Created by apple on 22/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class DreamSeasonController: UIViewController {
    @IBOutlet weak var txtMyDream: UILabel!
    
    @IBAction func btnClear(_ sender: Any) {
        txtDream.text = ""
    }
    
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var txtDrea: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnSave(_ sender: Any) {
        if(currentReachabilityStatus != .notReachable)
        {
        if let dream = txtDream.text?.trimmingCharacters(in: .whitespaces), dream.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("dream_season"), Message: LocalisationManager.localisedString("enter_dream_season_error"))
        }
         else
         {
             let dream = txtDream.text.trimmingCharacters(in: .whitespaces)
             addAPICALL(dream : dream)
         }
    }
    else{
        alertFailure(title: StringConstant.NO_INTERNET, Message: StringConstant.NO_INTER)
    }
        
    }
   
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtDream: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
       setBorder10(viewName: txtDream , radius:  10)
        setBorder10(viewName: btnSave, radius: 23)
        
     let season =  "\(UserDefaults.standard.value(forKey: Constant.DREAM_GOAL)!)"
        txtDream.text = season
        btnClear.isHidden = true
        if txtDream.text.count > 1
        {
            btnClear.isHidden = false
        }
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        txtDrea.text = LocalisationManager.localisedString("dream_season")
        txtMyDream.text = LocalisationManager.localisedString("my_dream_season")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtDrea.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtMyDream.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtDream.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        txtMyDream.textColor = .white
        txtDream.tintColor = .white
    }
    
    func addAPICALL(dream : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["dream_goal": dream , "lang" : lang]
        APIManager.shared.requestService(withURL: Constant.addDreamGoalsAPI, method: .post, param: param , header: header, viewController: self) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                    //                let data =   getDataFrom(JSON: json)
//                    let datat =  try json.rawData(options: .prettyPrinted)
                self.alertSucces(title: Constant.SUCCESS, Message: "\(json["message"])")
                UserDefaults.standard.set(dream, forKey: Constant.DREAM_GOAL)
        }
            
            else
            {
                alertFailure(title: Constant.FAILED, Message: "\(json["message"])")
            }
        }
        
        
    }
    
}
