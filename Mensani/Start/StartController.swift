//
//  StartController.swift
//  Mensani
//
//  Created by apple on 22/05/23.
//

import UIKit

class StartController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnback(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var txtVisualPoint: UILabel!
    @IBOutlet weak var txtSelfPoint: UILabel!
    @IBOutlet weak var txtPerformancePoint: UILabel!
    @IBOutlet weak var txtGoalPoints: UILabel!
    @IBOutlet weak var vPerformance: UIView!
    @IBOutlet weak var vWellBeing: UIView!
    @IBOutlet weak var vSelfTalk: UIView!
    @IBOutlet weak var vVisual: UIView!
    @IBOutlet weak var vGoals: UIView!
    @IBOutlet weak var btnGoals: UIButton!
    @IBOutlet weak var btnVisualize: UIButton!
    @IBOutlet weak var btnSelf: UIButton!
    @IBOutlet weak var btnPerformance: UIButton!
    @IBOutlet weak var btnWellbeing: UIButton!
    
    @IBOutlet weak var txtEvent: UILabel!
    @IBOutlet weak var txtPre: UILabel!
    
    @IBOutlet weak var txtPost: UILabel!
    
    @IBOutlet weak var txtOpt: UILabel!
    @IBOutlet weak var txtIn: UILabel!
    
    @IBAction func btnGoals(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "prisecstart") as? StartGoalsController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            self.alertInternet()
        }
        
    }
    
    @IBAction func btnVisual(_ sender: Any) {
       
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "visself") as? VisualSelfController
            vc?.flag = 0
            UserDefaults.standard.set("0", forKey: Constant.VIEW_SELECTED)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            self.alertInternet()
        }
        
    }
    
    @IBAction func btnPerfor(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "performance") as? PerformController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            self.alertInternet()
        }
        
    }
    
    @IBAction func btnSelf(_ sender: Any) {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "visself") as? VisualSelfController
            vc?.flag = 1
            UserDefaults.standard.set("1", forKey: Constant.VIEW_SELECTED)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            self.alertInternet()
        }
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "rec") as? RecordController
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func btnWell(_ sender: Any) {
        
        if(self.currentReachabilityStatus != .notReachable)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "wellbeing") as? WellbeingController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else
        {
            self.alertInternet()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      setBorder10(viewName: btnGoals, radius: 23)
      setBorder10(viewName: btnVisualize, radius: 23)
      setBorder10(viewName: btnSelf, radius: 23)
      setBorder10(viewName: btnPerformance, radius: 23)
      setBorder10(viewName: btnWellbeing, radius: 23)
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnGoals.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnVisualize.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnSelf.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnPerformance.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnWellbeing.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtIn.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtPre.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtPost.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        txtOpt.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
        txtIn.text = LocalisationManager.localisedString("in_event")
        txtPre.text = LocalisationManager.localisedString("pre")
        txtOpt.text = LocalisationManager.localisedString("optional")
        txtPost.text = LocalisationManager.localisedString("post_event")
        txtEvent.text = LocalisationManager.localisedString("event")
        
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnPerformance.setTitle(LocalisationManager.localisedString("performance"), for: .normal)
    
        btnGoals.setTitle(LocalisationManager.localisedString("goals"), for: .normal)
        btnVisualize.setTitle(LocalisationManager.localisedString("visulization"), for: .normal)
        btnSelf.setTitle(LocalisationManager.localisedString("self_talk"), for: .normal)
        btnWellbeing.setTitle(LocalisationManager.localisedString("well_being"), for: .normal)
        
     
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
      
        setPoints()
    }
    
    func setPoints()
    {
        txtSelfPoint.text = "  +" +  "\(UserDefaults.standard.string(forKey: Constant.START_SELF_POINT)!)" + "  "
        txtGoalPoints.text = "  +" +   "\(UserDefaults.standard.string(forKey: Constant.START_GOAL_POINT)!)"  + "  "
        txtVisualPoint.text = "  +" +  "\(UserDefaults.standard.string(forKey: Constant.VISUALIZATION_POINTS)!)"  + "  "
        txtPerformancePoint.text = "  +" +  "\(UserDefaults.standard.string(forKey: Constant.PERFORMANCE_POINTS)!)"  + "  "
    }

}
