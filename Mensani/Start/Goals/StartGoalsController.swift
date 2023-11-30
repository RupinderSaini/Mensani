//
//  StartGoalsController.swift
//  Mensani
//
//  Created by apple on 12/06/23.
//

import UIKit

class StartGoalsController: UIViewController, SeasonDelegate {
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtGoals: UILabel!
    @IBOutlet weak var txtSec: UILabel!
    @IBOutlet weak var txtPrim: UILabel!
    func sendFailure(handleString: String, type : Int) {
        if type == 1
        {
            alertSucces(title:  LocalisationManager.localisedString("goals"), Message: handleString)
        }
        else
        {
            alertFailure(title: LocalisationManager.localisedString("failed"), Message: handleString)
        }
    }
   

    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
  
   
    @IBAction func btnSave(_ sender: Any) {
        let edPri = edPrimary.text.trimmingCharacters(in: .whitespaces)
        let edSec = edSecondary.text.trimmingCharacters(in: .whitespaces)
        viewModel.sendValues(primary: edPri, secondary: edSec, controller: self , callFrom: true)
    }
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var edSecondary: UITextView!
    @IBOutlet weak var edPrimary: UITextView!
    lazy var viewModel = {
           PriSecSeasonVM()
       }()
    
    
    func initViewModel() {
        viewModel.delegate = self
       }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setBorder10(viewName: edPrimary , radius:  10)
        setBorder10(viewName: edSecondary, radius:  10)
        setBorder10(viewName: btnSave, radius: 23)
        initViewModel()
        let primaryGoal = UserDefaults.standard.string(forKey: Constant.START_PRIMARY_GOAL)
        let secondGoal = UserDefaults.standard.string(forKey: Constant.START_SECONDARY_GOAL)
        
        edPrimary.text = primaryGoal
        edSecondary.text = secondGoal
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
       
        txtSec.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtPrim.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        txtPrim.text = LocalisationManager.localisedString("primary_goal")
        txtSec.text = LocalisationManager.localisedString("second_goal")
        txtGoals.text = LocalisationManager.localisedString("goals")
        
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
    
    }
    
}
