//
//  PerformController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 22/11/23.
//

import UIKit
import Alamofire

class PerformController: UIViewController , UITextViewDelegate {
    @IBOutlet weak var txtAddPerImp: UILabel!
    @IBOutlet weak var txtPerfor: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txt1: UILabel!
    @IBOutlet weak var txt2: UILabel!
    @IBOutlet weak var txt3: UILabel!
    @IBOutlet weak var txt4: UILabel!
    @IBOutlet weak var vp3: UIView!
    @IBOutlet weak var vp2: UIView!
    @IBOutlet weak var vp1: UIView!
    @IBOutlet weak var vp4: UIView!
    @IBOutlet weak var txtFour: UILabel!
   
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var txtP4: UILabel!
    @IBOutlet weak var txtP3: UILabel!
    @IBOutlet weak var txtP2: UILabel!
    @IBOutlet weak var txtP1: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
  
    @IBOutlet weak var vpp1: UIView!
    @IBOutlet weak var txtI1: UILabel!
    @IBOutlet weak var txtOne: UILabel!
    
    @IBOutlet weak var txtImp: UILabel!
    
    @IBAction func btnSave(_ sender: Any) {
        
        if position != 5
        {
            if  edPerformace.text.trimmingCharacters(in: .whitespaces).isEmpty
            {
                alertFailure(title: LocalisationManager.localisedString("enter_perfor"), Message:  LocalisationManager.localisedString( "error_enter_perfor"))
            }
            else
            {
                addAPICALL(performance: edPerformace.text.trimmingCharacters(in: .whitespaces))
            }
        }
        else
        {
            if  edPerformace.text.trimmingCharacters(in: .whitespaces).isEmpty
            {
                alertFailure(title: LocalisationManager.localisedString("enter_imp"), Message:  LocalisationManager.localisedString( "error_enter_imp"))
            }
            else
            {
                addAPIImpCALL(performance: edPerformace.text.trimmingCharacters(in: .whitespaces))
            }
        }
//            viewModel.sendValues(performance: edPerformace.text.trimmingCharacters(in: .whitespaces), sequence: position , controller: self)
        
    }
    @IBAction func btnCancel(_ sender: Any) {
        viewAdd.isHidden = true
    }
    @IBOutlet weak var edPerformace: UITextView!
    @IBOutlet weak var viewAdd: UIView!
//    @IBOutlet weak var imgAdd: UIImageView!
    
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    lazy var viewModel = {
          PerformanceVM()
       }()
    
    var position = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAdd.isHidden = true
       
        edPerformace.delegate = self
        
        setupToHideKeyboardOnTapOnView()
       
        txt1.layer.cornerRadius = txt1.frame.height/2
        txt1.clipsToBounds = true
        
        txt2.layer.cornerRadius = txt2.frame.height/2
        txt2.clipsToBounds = true
        
        txt3.layer.cornerRadius = txt3.frame.height/2
        txt3.clipsToBounds = true
        
        txt4.layer.cornerRadius = txt4.frame.height/2
        txt4.clipsToBounds = true
        
        txtI1.layer.cornerRadius = txtI1.frame.height/2
        txtI1.clipsToBounds = true
        
        setBorder10(viewName: vp1, radius: 8)
        setBorder10(viewName: vp2, radius: 8)
        setBorder10(viewName: vp3, radius: 8)
        setBorder10(viewName: vp4, radius: 8)
        setBorder10(viewName: vpp1, radius: 8)
        setBorder10(viewName: viewAdd, radius: 8)
        setBorder10(viewName: edPerformace, radius: 10)
        
        setBorder10(viewName: btnSave, radius: 20)
        setBorder10(viewName: btnCancel, radius: 20)
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        txtFour.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtAddPerImp.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        edPerformace.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtOne.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtFour.text = LocalisationManager.localisedString("did_well")
        btnCancel.setTitle(LocalisationManager.localisedString("cancel"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        btnSave.backgroundColor =  hexStringToUIColor(hex: color ?? "#fff456")
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        
        txtPerfor.text = LocalisationManager.localisedString("performance")
        txtPerfor.text = LocalisationManager.localisedString("performance")
        txtOne.text = LocalisationManager.localisedString("imp_two")
        
        let improve = UserDefaults.standard.string(forKey: Constant.IMPROVEMENT)
        txtImp.text = improve
        
        vp1.isUserInteractionEnabled = true
        vp1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall)))
        
        vp2.isUserInteractionEnabled = true
        vp2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall2)))
        
        vp3.isUserInteractionEnabled = true
        vp3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall3)))
        
        vp4.isUserInteractionEnabled = true
        vp4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall4)))
        
        vpp1.isUserInteractionEnabled = true
        vpp1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addCall5)))
        
        performanceAPICALL()
    }
    
   
    @objc func addCall5()
    {
        position = 5
        viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("enter_imp")
        edPerformace.text = txtImp.text
    }
    
    @objc func addCall()
    {
        position = 1
        viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        edPerformace.text = txtP1.text

    }
    
    @objc func addCall2()
    {
        position = 2
        viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        edPerformace.text = txtP2.text
    }
    
    @objc func addCall3()
    {
        position = 3
        viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        edPerformace.text = txtP3.text
    }
    
    @objc func addCall4()
    {
        position = 4
        viewAdd.isHidden = false
        txtAddPerImp.text = LocalisationManager.localisedString("add_performance")
        edPerformace.text = txtP4.text
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
                        switch model.data[i].sequence
                        {
                        case 1 :
                            self.txtP1.text = model.data[i].performance
                        case 2 :
                            self.txtP2.text = model.data[i].performance
                        case 3 :
                            self.txtP3.text = model.data[i].performance
                        case 4 :
                            self.txtP4.text = model.data[i].performance
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
    
    func addAPICALL( performance : String )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["performance": performance , "id" : position.description]
        print(param)
        APIManager.shared.requestService(withURL: Constant.addPerformanceAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
                    self.position = 0
                    self.viewAdd.isHidden = true
//                    self.setData(model : model.data , count : model.data.count)
                    for i in 0..<model.data.count
                    {
                        switch model.data[i].sequence
                        {
                        case 1 :
                            self.txtP1.text = model.data[i].performance
                        case 2 :
                            self.txtP2.text = model.data[i].performance
                        case 3 :
                            self.txtP3.text = model.data[i].performance
                        case 4 :
                            self.txtP4.text = model.data[i].performance
                        default :
                            print("fcecec")
                        }
                    }
//                    UserDefaults.standard.set(model.da , forKey: Constant.PERFORMACE_ADD)
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
    
    func addAPIImpCALL( performance : String)
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
                self.txtP1.text = self.edPerformace.text
                    UserDefaults.standard.set(self.edPerformace.text, forKey: Constant.IMPROVEMENT)
                self.edPerformace.text = ""
               
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
    
    func setData(model : [DatumPerformance], count : Int)
    {
        for i in 0..<count
        {
            print(i)
            print(model[i].sequence)
            switch i {
            case model[i].sequence:
                txtP1.text = model[i].performance
            case model[i].sequence:
                txtP2.text = model[i].performance
            case model[i].sequence:
                txtP3.text = model[i].performance
            case model[i].sequence:
                txtP4.text = model[i].performance
            default:
                print("qwerty")
            }
        }
    }
    var max = 120
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = edPerformace.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }
        txtCount.text = "\(newText.count)/\(max)"
        return (newText.count + text.count) <= 120
    }
}
