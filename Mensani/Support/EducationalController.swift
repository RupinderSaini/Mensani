//
//  EducationalController.swift
//  Mensani
//
//  Created by apple on 30/06/23.
//

import UIKit
import Alamofire
import Kingfisher
import AVFoundation
import AVKit

class EducationalController: UIViewController ,  UITableViewDelegate, UITableViewDataSource {
    var position = 0
    var arrOfVideos : [DatumVideos] = []
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib2 = SupportCell.nib
        tableView.register(nib2, forCellReuseIdentifier:SupportCell.identifier)

//            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
       
        if(self.currentReachabilityStatus != .notReachable)
        {
        eduAPICALL()
}
        else
        {
            self.alertInternet()
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: SupportCell.identifier, for: indexPath) as! SupportCell
        cell2.txtName.text = arrOfVideos[indexPath.row].title
     
        if !"\(arrOfVideos[indexPath.row].price)".lowercased().contains("free")
        {
            let color = UserDefaults.standard.string(forKey: Constant.TEAMCOLOR)
           
            cell2.btnViews.backgroundColor = hexStringToUIColor(hex: color ?? "#fff456")
            cell2.btnViews.setTitle(LocalisationManager.localisedString("buy"), for: .normal)
        }
        else
        {
            
            cell2.btnViews.isHidden = true
        }
       
       
        let processor = DownsamplingImageProcessor(size:cell2.imgThumbnail.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlYourURL = URL (string: arrOfVideos[indexPath.row].thumbnail.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! )
//        cell2.imgRest.kf.indicatorType = .activity
        cell2.imgThumbnail.kf.setImage(
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
        return cell2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
        if "\(arrOfVideos[indexPath.row].price)".lowercased().contains("free")
        {
            let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "play") as! PlayVideoController
            pushControllerObj.strURL  = arrOfVideos[position].video!.description
            pushControllerObj.strName = arrOfVideos[position].title
            self.navigationController?.pushViewController(pushControllerObj, animated: true)
//            performSegue(withIdentifier: "play", sender: nil)
        }
        else
        {
          if   "\(arrOfVideos[indexPath.row].price)".lowercased().contains("paid")
            {
              let sid = UserDefaults.standard.string(forKey: Constant.SUBSCRIPTION_ID)
              if sid != ""
              {
                  let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "play") as! PlayVideoController
                  pushControllerObj.strURL  = arrOfVideos[position].video!.description
                  pushControllerObj.strName = arrOfVideos[position].title
                  self.navigationController?.pushViewController(pushControllerObj, animated: true)
              }
              else
              {
                  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "subsc") as? SubscriptionController
                 
                  self.navigationController?.pushViewController(vc!, animated: true)
              }
          }
            else
            {
                let pushControllerObj = mainStoryboard.instantiateViewController(withIdentifier: "web") as! WebViewController
                pushControllerObj.url  = arrOfVideos[position].ebookURL.description
                pushControllerObj.callFrom = 1
                self.navigationController?.pushViewController(pushControllerObj, animated: true)
            }
    }
//    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "play") as? PlayVideoController
//    vc?.strURL = arrOfVideos[indexPath.row].video.description
//    vc?.strName = arrOfVideos[indexPath.row].title
//    self.navigationController?.pushViewController(vc!, animated: true)
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if arrOfVideos[position].video != nil{
            let secondViewController = segue.destination as! PlayVideoController
            secondViewController.strURL  = arrOfVideos[position].video!.description
            secondViewController.strName = arrOfVideos[position].title
        }
       
    }
    func eduAPICALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
     
        let lang = LocalData.getLanguage(LocalData.language)
        let param = ["category_name": "Educational Support" , "lang" : lang]
        print(param)
        APIManager.shared.requestService(withURL: Constant.supportAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SupportResponse.self, from: data)
//                    for i in 0..<model.data.count
//                    {
//                        if model.data[i].supportType == "Educational Support"
//                        {
//                            self.arrOfVideos.append(model.data[i])
//                        }
//                    }
                    self.arrOfVideos = model.data
                 
//                    self.subId = model.subscriptionID
//                    if (self.arrOfPlans.count > 0)
//                    {
//                        self.txtNoData.isHidden = true
                        self.tableView.reloadData()
//                    }
//                    else
//                    {
//                        self.txtNoData.isHidden = false
//                    }
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



//
