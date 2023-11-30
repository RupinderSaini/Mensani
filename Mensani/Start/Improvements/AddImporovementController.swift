//
//  AddImporovementController.swift
//  Mensani
//
//  Created by apple on 25/05/23.
//

import UIKit

class AddImporovementController: UIViewController {
    @IBOutlet weak var txtPerform: UITextView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnSave(_ sender: Any) {
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
    

    

}
