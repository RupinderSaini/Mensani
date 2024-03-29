//
//  PrimarySecSeasonController.swift
//  Mensani
//
//  Created by apple on 22/05/23.
//

import UIKit

class PrimarySecSeasonController: UIViewController ,SeasonDelegate {
    func sendFailure(handleString: String, type : Int) {
        if type == 1
        {
            alertSucces(title: LocalisationManager.localisedString("season_goals"), Message: handleString)
        }
        else
        {
            alertFailure(title: LocalisationManager.localisedString("season_goals"), Message: handleString)
        }
    }
    
    @IBOutlet weak var txtSeasonGoal: UILabel!
    @IBOutlet weak var txtSecondary: UILabel!
    @IBOutlet weak var txtPrimary: UILabel!
    
    @IBAction func btnClear(_ sender: Any) {
        edPrimary.text = ""
        edSecondary.text = ""
    }
    
    
    @IBOutlet weak var btnClear: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
  
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnSave(_ sender: Any) {
        let edPri = edPrimary.text.trimmingCharacters(in: .whitespaces)
        let edSec = edSecondary.text.trimmingCharacters(in: .whitespaces)
        viewModel.sendValues(primary: edPri, secondary: edSec, controller: self , callFrom: false)
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
        
        let primaryGoal = UserDefaults.standard.string(forKey: Constant.SEASON_PRIMARY_GOAL)
        let secondGoal = UserDefaults.standard.string(forKey: Constant.SEASON_SECONDARY_GOAL)
        
        edPrimary.text = primaryGoal
        edSecondary.text = secondGoal
        btnClear.isHidden = true
        if edPrimary.text.count > 1
        {
            btnClear.isHidden = false
        }
       
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
    
        txtPrimary.text = LocalisationManager.localisedString("primary_seas_goal")
        txtSecondary.text = LocalisationManager.localisedString("second_sec_goal")
        txtSeasonGoal.text = LocalisationManager.localisedString("season_goals")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")

//        txtSecondary.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtPrimary.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        edPrimary.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
//        edSecondary.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        
        
        txtSecondary.textColor = .white
        txtPrimary.textColor = .white
        edPrimary.tintColor = .white
        edSecondary.tintColor = .white
//        txtSeasonGoal.textColor = hexStringToUIColor(hex: color ?? "#fff456")
    }
}
