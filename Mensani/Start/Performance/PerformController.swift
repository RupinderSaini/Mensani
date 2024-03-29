//
//  PerformController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 22/11/23.
//

import UIKit
import Alamofire

class PerformController: UIViewController , UITextViewDelegate {
  
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var txtPerfor: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txt1: UILabel!
    @IBOutlet weak var txt2: UILabel!
    @IBOutlet weak var txt3: UILabel!
//    @IBOutlet weak var txt4: UILabel!
   
    @IBOutlet weak var txtV4: UITextView!
    @IBOutlet weak var txtV3: UITextView!
    @IBOutlet weak var txtV2: UITextView!
    @IBOutlet weak var txtV1: UITextView!
    @IBOutlet weak var vp1: UIView!
//    @IBOutlet weak var vp4: UIView!
    @IBOutlet weak var txtFour: UILabel!
   
    @IBAction func btnClear(_ sender: Any) {
        txtV1.text = " "
        txtV2.text = " "
        txtV3.text = " "
        txtV4.text = " "
    }
//    @IBOutlet weak var txtCount: UILabel!

  
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vpp1: UIView!
    @IBOutlet weak var txtI1: UILabel!
    @IBOutlet weak var txtOne: UILabel!
    
    @IBOutlet weak var txtImp: UILabel!
    
    @IBAction func btnSave(_ sender: Any) {
        getValues()
//        viewAdd.isHidden = true
//        if position != 5
//        {
//            if  edPerformace.text.trimmingCharacters(in: .whitespaces).isEmpty
//            {
//                alertFailure(title: LocalisationManager.localisedString("enter_perfor"), Message:  LocalisationManager.localisedString( "error_enter_perfor"))
//            }
//            else
//            {
//                addAPICALL(performance: edPerformace.text.trimmingCharacters(in: .whitespaces))
//            }
//        }
//        else
//        {
//            if  edPerformace.text.trimmingCharacters(in: .whitespaces).isEmpty
//            {
//                alertFailure(title: LocalisationManager.localisedString("enter_imp"), Message:  LocalisationManager.localisedString( "error_enter_imp"))
//            }
//            else
//            {
//                addAPIImpCALL(performance: edPerformace.text.trimmingCharacters(in: .whitespaces))
//            }
//        }
//            viewModel.sendValues(performance: edPerformace.text.trimmingCharacters(in: .whitespaces), sequence: position , controller: self)
        
    }

    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    lazy var viewModel = {
          PerformanceVM()
       }()
    
    var position = 0
    override func viewDidLoad() {
        super.viewDidLoad()
 setupToHideKeyboardOnTapOnView()
       
        btnClear.isHidden = true
        txt1.layer.cornerRadius = txt1.frame.height/2
        txt1.clipsToBounds = true
        
        txt2.layer.cornerRadius = txt2.frame.height/2
        txt2.clipsToBounds = true
        
        txt3.layer.cornerRadius = txt3.frame.height/2
        txt3.clipsToBounds = true
        
        txtI1.layer.cornerRadius = txtI1.frame.height/2
        txtI1.clipsToBounds = true
        
        setBorder10(viewName: vp1, radius: 8)
        setBorder10(viewName: txtV1, radius: 8)
        setBorder10(viewName: txtV2, radius: 8)
        setBorder10(viewName: txtV3, radius: 8)
        setBorder10(viewName: txtV4, radius: 8)
        setBorder10(viewName: btnSave, radius: 8)
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        txtFour.textColor = .white
       
//        txtV1.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtV2.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtV3.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtV4.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtOne.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        txtV1.tintColor = .white
        txtV2.tintColor = .white
        txtV3.tintColor = .white
        txtV4.tintColor = .white
        txtOne.textColor = .white
        txtFour.text = LocalisationManager.localisedString("did_well")

        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.backgroundColor =  hexStringToUIColor(hex: color ?? "#fff456")
 
        txtPerfor.text = LocalisationManager.localisedString("performance")
        txtOne.text = LocalisationManager.localisedString("imp_two")
        
        let improve = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT)
        txtV4.text = improve
 
        
        performanceAPICALL()
    }
    
   func getValues()
    {
        let  per1 =   txtV1.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let  per2 =   txtV2.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let  per3 =   txtV3.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let  per4 =   txtV4.text.trimmingCharacters(in: .whitespacesAndNewlines)
    
        if per1.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("add_performance"), Message: LocalisationManager.localisedString("error_enter_perfor"))
        }
        else if per2.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("add_performance"), Message: LocalisationManager.localisedString("error_enter_perfor"))
        }
        else if per3.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("add_performance"), Message: LocalisationManager.localisedString("error_enter_perfor"))
        }
        else if per4.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("enter_imp1"), Message: LocalisationManager.localisedString("error_enter_imp"))
        }
        else
        {
        
            addAPINewCALL()
        }
    }

    
    func performanceAPICALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "0"]
        APIManager.shared.requestService(withURL: Constant.getPerformanceAPI, method: .post, param: param , header: header, viewController: self) {  (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
                    for i in 0..<model.data.count
                    {
                        self.btnClear.isHidden = false
                        switch model.data[i].sequence
                        {
                        case 1 :
                            self.txtV1.text = model.data[i].performance
                        case 2 :
                            self.txtV2.text = model.data[i].performance
                        case 3 :
                            self.txtV3.text = model.data[i].performance
//                        case 4 :
//                            self.txtP4.text = model.data[i].performance
                        default :
                            print("fcecec")
                        }
                    }
                    
                }
                catch {
                    print("exception")
                    print(error)
                }
            }
            else if("\(json["status"])" == "2")
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
 
    
    func addAPINewCALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        var arr : [String] = []
        arr.append(txtV1.text)
        arr.append(txtV2.text)
        arr.append(txtV3.text)
        let imp =  txtV4.text.description
        let lang = LocalData.getLanguage(LocalData.language)
        print(header)
        let param = ["performance": arr, "improvement" : imp , "lang" : lang] as [String : Any]
        print(param)
        APIManager.shared.requestService(withURL: Constant.addPerformanceNewAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
//                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
                    self.position = 0
                    self.alertSucces(title: LocalisationManager.localisedString("performance"), Message: "\(json["message"])")
//                    self.viewAdd.isHidden = true
//                    self.setData(model : model.data , count : model.data.count)
                  
                    UserDefaults.standard.set(self.txtV4.text.description , forKey: Constant.IMPROVEMENT)
//                    self.fetchData(noti: model)
                }
                catch {
                    print("exception")
                }
            }
            else if("\(json["status"])" == "2")
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
    func setData(model : [DatumPerformance], count : Int)
    {
        for i in 0..<count
        {
            btnClear.isHidden = false
            print(i)
            print(model[i].sequence)
            switch i {
            case model[i].sequence:
                txtV1.text = model[i].performance
            case model[i].sequence:
                txtV2.text = model[i].performance
            case model[i].sequence:
                txtV3.text = model[i].performance
//            case model[i].sequence:
//                txtP4.text = model[i].performance
            default:
                print("qwerty")
            }
        }
    }
    var max = 120
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = txtV1.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }
//        txtCount.text = "\(newText.count)/\(max)"
        return (newText.count + text.count) <= 120
    }
}
