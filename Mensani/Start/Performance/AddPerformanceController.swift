//
//  AddPerformanceController.swift
//  Mensani
//
//  Created by apple on 25/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddPerformanceController: UIViewController {

    @IBOutlet weak var txtPerform: UITextView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnSave(_ sender: Any) {
        
        if let dream = txtPerform.text?.trimmingCharacters(in: .whitespaces), dream.isEmpty
        {
            alertFailure(title: StringConstant.FAILED, Message: StringConstant.PERFORMANCE)
        }
         else
         {
             let dream = txtPerform.text.trimmingCharacters(in: .whitespaces)
             addAPICALL(performance : dream)
         }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var btnSave: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        setBorder10(viewName: btnSave, radius: 20)
        setBorder10(viewName: btnCancel, radius: 20)
        setBorder10(viewName: txtPerform, radius: 10)
    }
    
    func addAPICALL(performance : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
//        var arra : [Any] = [performance]
//        arra.append(performance)
        let param = ["performance": performance]
        print(param)
        APIManager.shared.requestService(withURL: Constant.addPerformanceAPI, method: .post, param: param , header: header, viewController: self) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                    //                let data =   getDataFrom(JSON: json)
//                    let datat =  try json.rawData(options: .prettyPrinted)
                self.alertSucces(title: Constant.SUCCESS, Message: "\(json["message"])")
                self.dismiss(animated: true)
            }
            
            else
            {
                alertFailure(title: Constant.FAILED, Message: "\(json["message"])")
            }
        }
        
        
    }
  
}
