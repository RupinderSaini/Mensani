//
//  ImproveController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 22/11/23.
//

import UIKit
import Alamofire

class ImproveController: UIViewController {
    @IBOutlet weak var txtP1: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var edPerform: UITextView!
    @IBOutlet weak var txtAdd: UILabel!
    @IBOutlet weak var vpp1: UIView!
    @IBOutlet weak var txt1: UILabel!
    @IBOutlet weak var txtOne: UILabel!
    
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var viewAdd: UIView!
    @IBAction func btnSave(_ sender: Any) {
    
        if  edPerform.text.trimmingCharacters(in: .whitespaces).isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("enter_imp"), Message:  LocalisationManager.localisedString( "error_enter_imp"))
        }
        else
        {
            addAPICALL(performance: edPerform.text.trimmingCharacters(in: .whitespaces))
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        viewAdd.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let improve = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT)
        txtP1.text = improve
        
        txtOne.text = LocalisationManager.localisedString("imp_two")
        txtAdd.text = LocalisationManager.localisedString("enter_imp")
        
        viewAdd.isHidden = true
        vpp1.isUserInteractionEnabled = true
        vpp1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
        
        imgAdd.isHidden = true
      
        setupToHideKeyboardOnTapOnView()
        setBorder10(viewName: btnSave, radius: 20)
        setBorder10(viewName: btnCancel, radius: 20)
        setBorder10(viewName: edPerform, radius: 10)
       
        setBorder10(viewName: vpp1, radius: 8)
        setBorder10(viewName: viewAdd, radius: 8)
        setBorder10(viewName: edPerform, radius: 10)
        setBorder10(viewName: edPerform, radius: 10)
        
        txt1.layer.cornerRadius = txt1.frame.height/2
        txt1.clipsToBounds = true
        
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        txtAdd.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtOne.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        edPerform.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        imgAdd.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        btnCancel.setTitle(LocalisationManager.localisedString("cancel"), for: .normal)
        btnSave.backgroundColor =  hexStringToUIColor(hex: color ?? "#fff456")
        
    }
    @objc func addCall()
    {
        
            viewAdd.isHidden = false
      
    }

    func addAPICALL( performance : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["improvement": performance , "id" : "1"]
        
        APIManager.shared.requestService(withURL: Constant.addImproveAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                self.viewAdd.isHidden = true
                self.txtP1.text = self.edPerform.text
                    UserDefaults.standard.set(self.edPerform.text, forKey: Constant.IMPROVEMENT)
                self.edPerform.text = ""
               
            }
            else if("\(json["status"])" == "2")
            {
                
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
}
