//
//  TherapistController.swift
//  Mensani
//
//  Created by apple on 06/07/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class TherapistController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    var arrOfAudio : [DatumTherapist] = []
  
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib2 = TherapistCell.nib
        tableView.register(nib2, forCellReuseIdentifier:TherapistCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        indicator.isHidden = true
        
        therapistAPICALL()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfAudio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: TherapistCell.identifier, for: indexPath) as! TherapistCell
        cell2.selectionStyle = .none
        cell2.txtName.text = arrOfAudio[indexPath.row].name
        
        cell2.txt1.text = arrOfAudio[indexPath.row].degree
        cell2.txt2.text = arrOfAudio[indexPath.row].license
        let processor = DownsamplingImageProcessor(size:cell2.imgThearpist.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 2)
        let urlYourURL = URL (string: arrOfAudio[indexPath.row].image?.description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "https://phpstack-102119-3423473.cloudwaysapps.com/storage/support_thumbnail//1686296146plogo.png" )
//        cell2.imgRest.kf.indicatorType = .activity
        cell2.imgThearpist.kf.setImage(
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

        cell2.btnVideo.tag = indexPath.row
        cell2.btnVideo.addTarget(self, action: #selector(acceptOrder(_:)), for: .touchUpInside)
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tpro") as? ProfileTController
        vc?.strId = arrOfAudio[indexPath.row].id.description
       
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func acceptOrder(_ sender: UIButton) {
        let position = sender.tag
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tvideo") as? TherapistVideoController
        vc?.strId = arrOfAudio[position].id.description
        vc?.strName = arrOfAudio[position].name
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func therapistAPICALL()
    {
        self.indicator.isHidden = false
        indicator.startAnimating()
       
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        AF.request(Constant.baseURL + Constant.therapistAPI , method: .get, headers: header).validate().responseJSON { (response) in
          debugPrint(response)
            
            switch response.result {
            case .success:
                //  print("Validation Successful)")
                self.indicator.isHidden = true
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let status = data["status"]
                        if(status == "1")
                        {
                            let model =  try JSONDecoder().decode(TherapistListResponse.self, from: response.data!)
                            
                            self.arrOfAudio = model.data
                           
                            if (self.arrOfAudio.count > 0)
                            {
        //                        self.txtNoData.isHidden = true
                                self.tableView.reloadData()
                            }
                            else
                            {
                                self.tableView.isHidden = true

        //                        self.txtNoData.isHidden = false
                            }
                        }
                        else
                        {
                            
                            
                        }
                    }
                    catch{
                        
//                        self.indicator.isHidden = true
                        print(error)
                    }
                    
                }
            case .failure(let error):
                print(error)
                
               
            }
        }
    }
   
    

}
