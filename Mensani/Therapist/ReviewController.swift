//
//  ReviewController.swift
//  Mensani
//
//  Created by apple on 10/07/23.
//

import UIKit
import Cosmos
import Alamofire

class ReviewController: UIViewController {

    @IBOutlet weak var txtRev: UILabel!
    var delegate : RefreshTherapistProfile?
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var edReview: UITextView!
   
    var rating : Double  = 0.0
    var strId = ""
    
    
    @IBAction func btnSave(_ sender: Any) {
         let rating =  "\(String(format: "%.2f", rating))"
       
        getValues(value: rating)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBorder10(viewName: edReview, radius: 10)
        setBorder10(viewName: btnSave, radius: 10)
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
        btnSave.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnSave.setTitle(LocalisationManager.localisedString("save"), for: .normal)
        txtRev.text =  LocalisationManager.localisedString("review")
        star.settings.fillMode = .precise
        star.settings.starSize = 40
        star.settings.starMargin = 5
        
        star.didFinishTouchingCosmos = { rating in
            print(rating)
            self.rating = (rating)
        }
        
        edReview.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
    }
    
    func getValues(value : String)
    {
        if let dream = edReview.text?.trimmingCharacters(in: .whitespaces), dream.isEmpty
        {
            alertFailure(title: LocalisationManager.localisedString("failed"), Message: LocalisationManager.localisedString("enter_rev_error"))
        }
         else
         {
             let dream = edReview.text.trimmingCharacters(in: .whitespaces)
             reviewAPICALL(review : dream , ratee : value)
         }
    }
    
    
    func reviewAPICALL(review : String, ratee : String)
    {

        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let userId = (UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID))!
  
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["therapist_id": strId , "stars" : ratee , "athlete_id" : userId, "feedback" : review]
      
        print(param)
        APIManager.shared.requestService(withURL: Constant.therapistReviewAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    self.delegate?.refreshList()
                    self.dismiss(animated: true)
                }
                catch {
                    print("exception")
                    print(error)
                }
            }
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
}
protocol RefreshTherapistProfile
{
    func refreshList()
}
