//
//  ProfileTController.swift
//  Mensani
//
//  Created by apple on 07/07/23.
//

import UIKit
import Alamofire
import Kingfisher

class ProfileTController: UIViewController , UITableViewDelegate, UITableViewDataSource , RefreshTherapistProfile {
    func refreshList() {
        profileAPICALL()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfReview.count
    }
    var strName = ""
    var strId = ""
    var strPhone = ""
    var amount = ""
    var arrOfReview : [TherapistReview] = []
  
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btncall: UIButton!
    @IBOutlet weak var lblHourly: UILabel!
    @IBOutlet weak var lblComp: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtClient: UILabel!
    @IBOutlet weak var txtComplete: UILabel!
    @IBOutlet weak var txtExperi: UILabel!
    @IBOutlet weak var txtLice: UILabel!
    @IBOutlet weak var txtEdu: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var vRound: UIView!
    @IBAction func btnback(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    @IBAction func btnChat(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            //https://phpstack-1020308-3605009.cloudwaysapps.com/chat/therapist_id/user_id/therapist
            let userId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "web") as? WebViewController
            vc?.callFrom = 2
            let lang = LocalData.getLanguage(LocalData.language)
            vc?.url = "\(Constant.baseURL)chat/\(strId)/\(userId)/therapist/\(lang)"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            alertInternet()
        }
    }
    @IBAction func btnReview(_ sender: Any) {
        
        lazy var sheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "review") as! ReviewController
        sheetVC.strId = strId
        sheetVC.delegate = self
        if #available(iOS 15.0, *) {
            if let sheet = sheetVC.sheetPresentationController{
                sheet.detents = [.medium() ]
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(sheetVC, animated: true, completion: nil)
    }
    @IBAction func btnAppoint(_ sender: Any) {
        
        lazy var sheetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "appoint") as! AppointmentController
        sheetVC.strId = strId
        sheetVC.strAmount = amount
//        if #available(iOS 15.0, *) {
//            if let sheet = sheetVC.sheetPresentationController{
//                sheet.detents = [.large() ]
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        self.navigationController?.pushViewController(sheetVC, animated: true)
//        self.present(sheetVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var vActive: UIView!
    @IBOutlet weak var yExp: UIView!
    @IBOutlet weak var vYrs: UIView!
    
    @IBAction func btnVideo(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tvideo") as? TherapistVideoController
        vc?.strId = strId
        vc?.strName = strName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btncall(_ sender: Any) {
        guard let number = URL(string: "tel://" + strPhone) else { return }
        UIApplication.shared.open(number)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let nib2 = ReviewCell.nib
        tableView.register(nib2, forCellReuseIdentifier:ReviewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
//        indicator.isHidden = true
        profileAPICALL()
        setBorder10(viewName: yExp, radius: 8)
        setBorder10(viewName: vYrs, radius: 8)
        setBorder10(viewName: vActive, radius: 8)
        setBorder10(viewName: btnAppointment, radius: 10)
//        setBorder10(viewName: btnChat, radius: 10)
        setBorder10(viewName: btnReview, radius: 10)
        btnBack.layer.cornerRadius = 8
        setLanguage()
//      
       
    }
    
    func setLanguage()
    {
        let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
       
        btnBack.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnAppointment.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnReview.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        btncall.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnChat.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        btnVideo.tintColor = hexStringToUIColor(hex: color ?? "#fff456")
        yExp.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        vYrs.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
        vActive.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
    
        
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        btnChat.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btncall.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnVideo.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        btnAppointment.setTitle(LocalisationManager.localisedString("appointment"), for: .normal)
        btnReview.setTitle(LocalisationManager.localisedString("review"), for: .normal)
        lblComp.text   = LocalisationManager.localisedString("comp")
        lblExperience.text   = LocalisationManager.localisedString("exp")
        lblHourly.text  = LocalisationManager.localisedString("act_clients")
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
        cell2.selectionStyle = .none
        cell2.txtName.text = arrOfReview[indexPath.row].athlete.name
        cell2.txtReview.text = arrOfReview[indexPath.row].feedback
        cell2.txtrating.text = " " + arrOfReview[indexPath.row].stars  + " "
        cell2.txtDay.text = arrOfReview[indexPath.row].duration
        let processor = DownsamplingImageProcessor(size:cell2.imgProfile.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlYourURL = URL (string: arrOfReview[indexPath.row].athlete.image?.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "https://phpstack-102119-3423473.cloudwaysapps.com/storage/support_thumbnail//1686296146plogo.png" )
//        cell2.imgRest.kf.indicatorType = .activity
        cell2.imgProfile.kf.setImage(
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

//        cell2.btnVideo.tag = indexPath.row
//        cell2.btnVideo.addTarget(self, action: #selector(acceptOrder(_:)), for: .touchUpInside)
        return cell2
    }

    func profileAPICALL( )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["therapist_id": strId , "lang" : lang]
        APIManager.shared.requestService(withURL: Constant.therapistProfileAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(TherapistInfoResponse.self, from: data)
                    self.arrOfReview = model.data.therapistReview
                
                    self.setData(data:  model.data.therapistProfile)

                    self.tableView.reloadData()
                    
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
    
    func setData( data : TherapistProfile)
    {
        amount = data.hourlyRate.description
        
        strPhone = data.phone
        strName = data.name
        
        txtName.text = data.name
        txtLice.text = data.license
        txtEdu.text = data.degree
        
        txtExperi.text = data.experience
        txtClient.text = "$" + data.hourlyRate.description
        txtComplete.text = data.completed
        
        let processor = DownsamplingImageProcessor(size:imgProfile.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlYourURL = URL (string: data.image.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "https://phpstack-102119-3423473.cloudwaysapps.com/storage/support_thumbnail//1686296146plogo.png" )
//        cell2.imgRest.kf.indicatorType = .activity
        imgProfile.kf.setImage(
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
    }

}
