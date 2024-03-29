//
//  PriSecSeasonVM.swift
//  Mensani
//
//  Created by apple on 12/06/23.
//

import Foundation
import Alamofire
import SwiftyJSON


class PriSecSeasonVM : NSObject
{
    var delegate: SeasonDelegate?
    
    // call from 0 = season goal, 1 = start goal
    func sendValues(primary : String? , secondary : String? , controller : UIViewController, callFrom : Bool)
    {
        var valueChanged = false
        var valueChangedSecond = false
        
        guard let pri = primary else
        {
            return
        }
        guard let sec = secondary else
        {
            return
        }
        let primaryGoal = UserDefaults.standard.string(forKey: Constant.START_PRIMARY_GOAL)
        let secondGoal = UserDefaults.standard.string(forKey: Constant.START_SECONDARY_GOAL)
        if !((pri.count>1) && (sec.count>1))
        {
            delegate?.sendFailure(handleString:  LocalisationManager.localisedString("enter_any_goal_error"), type: 0)
        }
      
         else
         {
            if ((primaryGoal == primary) && (secondGoal == secondary))
             {
                print("nmnmnmnm")
                print((primaryGoal == primary) && (secondGoal == secondary))
                valueChanged = false
//                addAPICALL(pri :pri, sec : sec ,  controller : controller, callFrom : callFrom)
            }
             else
             {
               var type = 0
                 if (primaryGoal != primary)
                  {
                   valueChanged = true
                 }
                  if  (secondGoal != secondary)
                  {
                     valueChangedSecond = true
                  }
                 var final = valueChanged && valueChangedSecond
                    print(final)
                 if final
                 {
                   type = 1
                 }
                
                 addAPICALL(pri :pri, sec : sec ,  controller : controller, callFrom : callFrom , valueChanged : type.description)
                
             }
         }
     }
    
    
    func addAPICALL(pri : String , sec : String , controller : UIViewController , callFrom : Bool , valueChanged : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
      
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["primary_goal": pri.description , "secondary_goal" : sec.description , "lang" : lang , "point_type" : valueChanged]
        print(param)
        var apiURL = ""
        if callFrom
        {
            apiURL = Constant.addStartGoalsAPI
        }
        else
        {
            apiURL = Constant.addSeasonGoalsAPI
        }
        APIManager.shared.requestService(withURL: apiURL, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                    //                let data =   getDataFrom(JSON: json)
//                    let datat =  try json.rawData(options: .prettyPrinted)
                delegate?.sendFailure(handleString: "\(json["message"])" , type: 1)
                
               if callFrom
                {
                   UserDefaults.standard.set(pri.description, forKey: Constant.START_PRIMARY_GOAL)
                   UserDefaults.standard.set(sec.description, forKey: Constant.START_SECONDARY_GOAL)
               }
                else
                {
                    UserDefaults.standard.set(pri.description, forKey: Constant.SEASON_PRIMARY_GOAL)
                    UserDefaults.standard.set(sec.description, forKey: Constant.SEASON_SECONDARY_GOAL)
                }
                
            }
            else if("\(json["status"])" == "2")
            {
                delegate?.sendFailure(handleString:  "\(json["message"])", type:  0)
            }
            
            else
            {
                delegate?.sendFailure(handleString:  "\(json["message"])" , type: 0)
            }
            
        }
        
    }
    
    
}
protocol SeasonDelegate
{
    func sendFailure(handleString : String , type : Int)
}
