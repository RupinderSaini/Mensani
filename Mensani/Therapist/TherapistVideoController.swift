//
//  TherapistVideoController.swift
//  Mensani
//
//  Created by apple on 06/07/23.
//

import UIKit
import Kingfisher
import Alamofire


class TherapistVideoController: UIViewController ,  UITableViewDelegate, UITableViewDataSource {
    var position = 0
    var arrOfVideos : [DatumTVideos] = []
    @IBOutlet weak var tableView: UITableView!
    var strId = ""
    @IBOutlet weak var txtNodata: UILabel!
    var strName = ""
    @IBOutlet weak var txtName: UILabel!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        txtName.text = strName
        txtNodata.text =    LocalisationManager.localisedString("support_videos_empty")
        txtNodata.isHidden = true
        
        let nib2 = SupportCell.nib
        tableView.register(nib2, forCellReuseIdentifier:SupportCell.identifier)

//            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        eduAPICALL()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: SupportCell.identifier, for: indexPath) as! SupportCell
        cell2.txtName.text = arrOfVideos[indexPath.row].title
        if "\(arrOfVideos[indexPath.row].price.lowercased())".contains("free")
        {
            cell2.txtPro.isHidden = true
        }
        else
        {
            cell2.txtPro.isHidden = false
        }
        cell2.btnViews.isHidden = true
//        cell2.btnViews.setTitle(arrOfVideos[indexPath.row].count.description + " views", for: .normal)
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
        
       
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "play") as? PlayVideoController
            vc?.strURL = arrOfVideos[indexPath.row].video.description
            vc?.strName = arrOfVideos[indexPath.row].title
            self.navigationController?.pushViewController(vc!, animated: true)
     
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if arrOfVideos[position].video.
            let secondViewController = segue.destination as! PlayVideoController
            secondViewController.strURL  = arrOfVideos[position].video.description
            secondViewController.strName = arrOfVideos[position].title
//        }
    }
    func eduAPICALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["therapist_id": strId]
        
        APIManager.shared.requestService(withURL: Constant.therapistVideoAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(TherapistVideoResponse.self, from: data)
                    self.arrOfVideos = model.data
                    
                    if self.arrOfVideos.count > 0
                    {
                        self.txtNodata.isHidden = true
                    }
                    else
                    {
                        self.txtNodata.isHidden = false
                    }

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
