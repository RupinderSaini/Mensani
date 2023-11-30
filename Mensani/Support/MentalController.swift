//
//  MentalController.swift
//  Mensani
//
//  Created by apple on 30/06/23.
//

import UIKit
import Alamofire
import Kingfisher

class MentalController: UIViewController ,  UITableViewDelegate, UITableViewDataSource {
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
//        if "\(arrOfVideos[indexPath.row].price)".contains("Free")
//        {
//            cell2.txtPro.isHidden = true
//        }
//        else
//        {
//            cell2.txtPro.isHidden = false
//        }
//        cell2.btnViews.setTitle(" " + arrOfVideos[indexPath.row].count.description + " views", for: .normal)
//        let processor = DownsamplingImageProcessor(size:cell2.imgThumbnail.bounds.size)
//                     |> RoundCornerImageProcessor(cornerRadius: 2)
//        let urlYourURL = URL (string: arrOfVideos[indexPath.row].thumbnail.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! )
////        cell2.imgRest.kf.indicatorType = .activity
//        cell2.imgThumbnail.kf.setImage(
//            with: urlYourURL,
////            placeholder: UIImage.init(systemName: "house")?.withTintColor(UIColor.gray) ,
//            options: [
//                .processor(processor),
//                .loadDiskFileSynchronously,
//                .cacheOriginalImage,
//                .transition(.fade(0.25))
//            ],
//            progressBlock: { receivedSize, totalSize in
//                // Progress updated
//            },
//            completionHandler: { result in
//                // Done
//            }
//            )
        return cell2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = indexPath.row
        if "\(arrOfVideos[indexPath.row].price)".contains("Free")
        {
            performSegue(withIdentifier: "play", sender: nil)
        }
        else
        {
            let sid = UserDefaults.standard.string(forKey: Constant.SUBSCRIPTION_ID)
            if sid != ""
            {
                performSegue(withIdentifier: "play", sender: nil)
            }
            
            else
            {
                alertUISubscribe()
            }
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
            let secondViewController = segue.destination as! PlayVideoController
//              secondViewController.strURL  = arrOfVideos[position].video.description
                secondViewController.strName = arrOfVideos[position].title
           
        }
    func eduAPICALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "type"]
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
//                        if model.data[i].supportType != "Educational Support"
//                        {
//                            self.arrOfVideos.append(model.data[i])
//                        }
//                    }
//
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
                }
            }
           
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
}
