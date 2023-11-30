//
//  LanguageController.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 24/11/23.
//

import UIKit

class LanguageController: UIViewController {

    @IBOutlet weak var txtSelected: UILabel!
    
  
  
    @IBOutlet weak var edLanguage: UITextField!
    @IBOutlet weak var txtLanguage: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSelected.text = LocalisationManager.localisedString("choose_language")
        txtLanguage.text = LocalisationManager.localisedString("language")
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        setupPicker()
        edLanguage.tintColor = .black
        edLanguage.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
    }
    

    var picker = UIPickerView()
    func setupPicker() {
        print("picker called")
        self.picker.backgroundColor = .white
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 150))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.setPicerData()
        self.edLanguage.inputView = self.picker
    }
    func setPicerData() {
        let languageCode = LocalData.getLanguage(LocalData.language)
        if let lang = languages.filter({$0.1 == languageCode}).first {
            self.edLanguage.text = lang.0
            self.picker.selectRow(lang.1 == "en" ? 0 : 1, inComponent: 0, animated: false)
        }
    }
}
extension LanguageController : UIPickerViewDelegate,UIPickerViewDataSource {
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
       
       self.edLanguage.resignFirstResponder()
       let language = languages[row]
       self.edLanguage.text = language.0
       //         print(language.0)
       self.setLanguage(language.1)
       
   }
}

