//
//  HomeViewController.swift
//  Mensani
//
//  Created by apple on 01/06/23.
//

import UIKit
import HGCircularSlider
import Alamofire
import Kingfisher
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var tabHome: UITabBarItem!
    @IBOutlet weak var imgTodayPlan: UIImageView!
    
    @IBOutlet weak var txtMoto: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtWeekly: UILabel!
    @IBOutlet weak var txtMonthly: UILabel!
    @IBOutlet weak var vToday: UIView!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var txtMessageFrom: UILabel!
    
    @IBOutlet weak var txtTime: UILabel!
    
    @IBOutlet weak var monthly: UILabel!
    @IBOutlet weak var weekly: UILabel!
    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet weak var txtAnswer: UILabel!
    
//    @IBOutlet weak var pDaily: CircularSlider!
    @IBOutlet weak var pMonthly: CircularSlider!
    @IBOutlet weak var pWeekly: CircularSlider!
    @IBOutlet weak var pDaily: CircularSlider!
    
    @IBOutlet weak var stackBtn: UIStackView!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSeason: UIButton!
    @IBAction func btnSeason(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "season") as? SeasonController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnStart(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start") as? StartController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnSupport(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "support") as? SupportController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var txtDaily: UILabel!
    
    @IBOutlet weak var daily: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder10(viewName: btnStart, radius: 15)
        setBorder10(viewName: btnSeason, radius: 15)
        setBorder10(viewName: btnSupport, radius: 15)
//        setBorder10(viewName: vToday, radius: 10)
       
        stackBtn.layer.cornerRadius=20
        stackBtn.clipsToBounds=true
//        viewBottom(viewBtn: viewBtn)
        
        setProgressView(slider: pWeekly , max: 30.05)
        setProgressView(slider: pMonthly, max: 100.05)
        setProgressView(slider: pDaily, max: 10.05)
      
        txtAnswer.text = LocalisationManager.localisedString("blank")
        btnStart.setTitle(LocalisationManager.localisedString("event"), for: .normal)
        btnSeason.setTitle(LocalisationManager.localisedString("season"), for: .normal)
        btnSupport.setTitle(LocalisationManager.localisedString("support"), for: .normal)
        
        daily.text =    LocalisationManager.localisedString("day")
        weekly.text =    LocalisationManager.localisedString("week")
        monthly.text =    LocalisationManager.localisedString("month")
        
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
//        daily.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        weekly.textColor = hexStringToUIColor(hex: color ?? "#fff456")
//        monthly.textColor = hexStringToUIColor(hex: color ?? "#fff456")
        
//        pWeekly.trackFillColor = hexStringToUIColor(hex: color ?? "#fff456")
//        pDaily.trackFillColor = hexStringToUIColor(hex: color ?? "#fff456")
//        pMonthly.trackFillColor = hexStringToUIColor(hex: color ?? "#fff456")
//       
        
        
//        homeAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        homeAPICall()
    }

    func homeAPICall()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        let lang = LocalData.getLanguage(LocalData.language)
        let strAPIToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let parameters = ["token" : strAPIToken , "lang" : lang]
        
        print("parameters",parameters)
        APIManager.shared.requestService(withURL: Constant.homeAPI, method: .post, param: parameters, header: header, viewController: self) { (json) in
         print(json)
            
            if("\(json["status"])" == "1")
            {
//                    let data = try json.rawData(options: .prettyPrinted)
//                    let model = try JSONDecoder().decode(HomeResponse.self, from: data)
                    self.setDataInView(model : json)
            }
            else
            {
                if "\(json["message"])".contains("Token")
                {
                    self.alertUIUnauthorised()
                }
                else
                {
                    self.alertFailure(title: Constant.FAILED, Message: "\(json["message"])")
                }
            }
           
        }
    }
    
    func setDataInView(model : JSON)
    {
//        txtQuestion.text = "\(model["data"]["question"])"
//        txtAnswer.text = "\(model["data"]["answer"])"
        
       
        let montly  = model["data"]["monthlypoints"].description
        let daily  = model["data"]["daypoints"].description
        let weekly  = model["data"]["weeklypoints"].description
        
        setProgress(day: daily, weekly: weekly, monthly: montly)
        
        //splash image
        UserDefaults.standard.set( "\(model["data"]["splash_image"].description)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), forKey: Constant.SPLASH_IMAGE)
        txtMoto.text = model["data"]["moto"].description
        //team image
        let processor = DownsamplingImageProcessor(size:imgTodayPlan.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlString = "\(model["data"]["home_image"].description)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let urlYourURL = URL (string: urlString! )
     
//        cell2.imgRest.kf.indicatorType = .activity
        imgTodayPlan.kf.setImage(
            with: urlYourURL,
//            placeholder: UIImage.init(systemName: "house")?.withTintColor(UIColor.gray) ,
            options: [
                .processor(processor),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { result in
                // Done
            }
        )

    
        
//        setTodayPlan(plan: model["data"]["todayplans"])

        //DREAM SEASON
        if model["data"]["dreamsGoal"].isEmpty
        {
            UserDefaults.standard.set("", forKey: Constant.DREAM_GOAL)
        }
        else
        {
            print("not nil")
          let dreamGoal =   model["data"]["dreamsGoal"]["dreamGoal"]
            UserDefaults.standard.set(dreamGoal, forKey: Constant.DREAM_GOAL)
        }
        
        //  sTART GOAL
        if model["data"]["start_goal"].isEmpty
        {
            UserDefaults.standard.set("", forKey: Constant.START_PRIMARY_GOAL)
            UserDefaults.standard.set("", forKey: Constant.START_SECONDARY_GOAL)
        }
        else
        {
            let priGoal =   model["data"]["start_goal"]["primary_goal"].description
            let secGoal =   model["data"]["start_goal"]["secondary_goal"].description
            UserDefaults.standard.set(priGoal, forKey: Constant.START_PRIMARY_GOAL)
            UserDefaults.standard.set(secGoal, forKey: Constant.START_SECONDARY_GOAL)
        }
        
        
        //SEASON GOALS
        if model["data"]["season_goal"].isEmpty
        {
            UserDefaults.standard.set("", forKey: Constant.SEASON_PRIMARY_GOAL)
            UserDefaults.standard.set("", forKey: Constant.SEASON_SECONDARY_GOAL)
        }
        else
        {
            let priGoal =   model["data"]["season_goal"]["primary_goal"].description
            let secGoal =   model["data"]["season_goal"]["secondary_goal"].description
            UserDefaults.standard.set(priGoal, forKey: Constant.SEASON_PRIMARY_GOAL)
            UserDefaults.standard.set(secGoal, forKey: Constant.SEASON_SECONDARY_GOAL)
        }
        // DREAM SEASON
        if model["data"]["dreams_goal"].isEmpty
        {
            UserDefaults.standard.set("", forKey: Constant.DREAM_GOAL)
        }
        else
        {
            let priGoal =   model["data"]["dreams_goal"]["dream_goal"].description
            UserDefaults.standard.set(priGoal, forKey: Constant.DREAM_GOAL)
        }
        
        //PostImprovement
        // DREAM SEASON
        if model["data"]["post_improvements"].isEmpty
        {
            UserDefaults.standard.set(" ", forKey: Constant.IMPROVEMENT)
        }
        else
        {
            let priGoal =   model["data"]["post_improvements"]["improvement"].description
            UserDefaults.standard.set(priGoal, forKey: Constant.IMPROVEMENT)
        }
        
        //ADMIN POINTS
        let startPoints =   model["data"]["admin_points"]["start_selftalks"].description
        let secGoal =   model["data"]["admin_points"]["start_goals"].description
        let visualization =   model["data"]["admin_points"]["visualization"].description
        let performace =   model["data"]["admin_points"]["performace"].description
        
        UserDefaults.standard.set(startPoints, forKey: Constant.START_SELF_POINT)
        UserDefaults.standard.set(secGoal, forKey: Constant.START_GOAL_POINT)
        UserDefaults.standard.set(visualization, forKey: Constant.VISUALIZATION_POINTS)
        UserDefaults.standard.set(performace, forKey: Constant.PERFORMANCE_POINTS)
        
        //USER INFO
        let teamColor = model["data"]["user_profile"]["team_color"].description
        let name =   model["data"]["user_profile"]["name"].description
        let email =   model["data"]["user_profile"]["email"].description
        let joinDate =   model["data"]["user_profile"]["time"].description
        let sports =   model["data"]["user_profile"]["sports_name"].description
        let id =   model["data"]["user_profile"]["id"].description
        let sid =   model["data"]["user_profile"]["subscription_id"].description
        let spid =   model["data"]["user_profile"]["sport_id"].description
        let tid =   model["data"]["user_profile"]["team_name"].description
        let teamType =   model["data"]["visibility"].description
        
        UserDefaults.standard.set(teamColor, forKey: Constant.TEAMCOLOR)
        UserDefaults.standard.set(teamType, forKey: Constant.TEAM_TYPE)
        UserDefaults.standard.set(name, forKey: Constant.NAME)
        UserDefaults.standard.set(email, forKey: Constant.EMAIL)
        UserDefaults.standard.set(joinDate, forKey: Constant.TIME_JOINED)
        UserDefaults.standard.set(sports, forKey: Constant.SPORTS)
        UserDefaults.standard.set(id, forKey: Constant.USER_UNIQUE_ID)

        UserDefaults.standard.set(spid, forKey: Constant.SPORTS_ID)
        UserDefaults.standard.set(tid, forKey: Constant.TEAM)
        if sid == ""
        {
            UserDefaults.standard.set("0", forKey: Constant.SUBSCRIPTION_ID)
        }
        else
        {
            UserDefaults.standard.set(sid, forKey: Constant.SUBSCRIPTION_ID)
        }
//        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
//        self.daily.textColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
//        self.weekly.textColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
//        self.monthly.textColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
        
//        pWeekly.trackFillColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
//        pDaily.trackFillColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
//        pMonthly.trackFillColor = hexStringToUIColor(hex: teamColor ?? "#fff456")
        //Season Self talk
        if  model["data"]["self_talk"]["role_model"].exists()
        {
          
            UserDefaults.standard.set("\(model["data"]["self_talk"]["role_model"])", forKey: Constant.ROLE_MODEL)
            UserDefaults.standard.set("\(model["data"]["self_talk"]["image"])", forKey: Constant.ROLE_IMAGE)
            UserDefaults.standard.set("\(model["data"]["self_talk"]["challenge"])", forKey: Constant.CHALLENGE)
            UserDefaults.standard.set("\(model["data"]["self_talk"]["role_model_traits"])", forKey: Constant.RECORDING)
        }
        else
        {
          
            UserDefaults.standard.set("", forKey: Constant.ROLE_MODEL)
            UserDefaults.standard.set("", forKey: Constant.ROLE_IMAGE)
            UserDefaults.standard.set("", forKey: Constant.CHALLENGE)
            UserDefaults.standard.set("", forKey: Constant.RECORDING)
        }
        //Wellbeing
        UserDefaults.standard.set("\(model["data"]["wellbeing"]["mood"])", forKey: Constant.WELLBEING_MOOD)
        UserDefaults.standard.set("\(model["data"]["wellbeing"]["thought"])", forKey: Constant.WELLBEING_THOUGHTS)
        
        //Add flag
       
        UserDefaults.standard.set("\(model["data"][" visualizations_flag"])", forKey: Constant.VISUAL_ADD)
        UserDefaults.standard.set("\(model["data"]["selftalks_flag"])", forKey: Constant.SELF_ADD)
     
        
        //User details
        UserDefaults.standard.set("\(model["data"]["user_profile"]["image"])", forKey:Constant.IMAGE)
        UserDefaults.standard.set("\(model["data"]["user_profile"]["name"])", forKey: Constant.NAME)
        UserDefaults.standard.set("\(model["data"]["user_profile"]["sports_name"])", forKey: Constant.SPORTS)
        UserDefaults.standard.set("\(model["data"]["user_profile"]["email"])", forKey: Constant.EMAIL)

    }
    
    func  setProgress(day : String , weekly : String , monthly : String)
    {
        txtDaily.text = "\(day)/10"
        txtWeekly.text = "\(weekly)/30"
        txtMonthly.text = "\(monthly)/100"
       print(day)
        if Int(day)! > 10
        {
            pDaily.endPointValue = 10
        }
        else
        {
            pDaily.endPointValue = CGFloat((day as NSString).doubleValue)
        }

        if Int(weekly)! > 30
        {
            pWeekly.endPointValue = 30
        }
        else
        {
            pWeekly.endPointValue = CGFloat((weekly as NSString).doubleValue)
        }
        
        if Int(weekly)! > 100
        {
            pMonthly.endPointValue = 100
        }
        else
        {
            pMonthly.endPointValue = CGFloat((monthly as NSString).doubleValue)
        }
            
//        pWeekly.endPointValue = CGFloat(("23" as NSString).doubleValue)
     
        pDaily.isEnabled = false
        pMonthly.isEnabled = false
        pWeekly.isEnabled = false
    }
    
    func setProgressView(slider : CircularSlider , max : CGFloat)
    {
        slider.minimumValue = 0.0
        slider.maximumValue = max
        slider.thumbLineWidth = 0.0
        slider.thumbRadius = 0.0
    }
    
    func setTodayPlan(plan : JSON)
    {
       
//        label.attributedText = attrStr
//        txtMessage.text = plan["description"].description.htmlToString
//        txtTime.text = plan["time"].description
//        txtMessageFrom.text = plan["message_from"].description + " " + plan["name"].description
//        txtDate.text = plan["validity"].description
        
        
    }
}
