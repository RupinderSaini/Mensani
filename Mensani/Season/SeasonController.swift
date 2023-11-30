//
//  SeasonController.swift
//  Mensani
//
//  Created by apple on 19/05/23.
//

import UIKit

class SeasonController: UIViewController {

    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnDream: UIButton!
    @IBOutlet weak var btnSelf: UIButton!
    @IBOutlet weak var btnSeason: UIButton!
    @IBOutlet weak var btnBack: UIButton!
   
    @IBOutlet weak var txtSeason: UILabel!
    @IBOutlet weak var txtOptional: UILabel!
    
    @IBAction func btnSeason(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "prisecseason") as? PrimarySecSeasonController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnDream(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dream") as? DreamSeasonController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSelf(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "selfsetup") as? SelfSetupController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        setBorder10(viewName: btnSeason, radius: 23)
        setBorder10(viewName: btnDream, radius: 23)
        setBorder10(viewName: btnSelf, radius: 23)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        txtOptional.text = LocalisationManager.localisedString("optional")
        txtSeason.text = LocalisationManager.localisedString("season")
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        btnSelf.setTitle(LocalisationManager.localisedString("self_talk_setup"), for: .normal)
        btnSeason.setTitle(LocalisationManager.localisedString("season_goals"), for: .normal)
        btnDream.setTitle(LocalisationManager.localisedString("dream_season"), for: .normal)
      
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSelf.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnDream.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnSeason.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        txtOptional.textColor = hexStringToUIColor(hex: color ?? "#fff456")
    }
    

    
}
