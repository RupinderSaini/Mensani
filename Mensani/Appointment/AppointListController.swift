//
//  AppointListController.swift
//  Mensani
//
//  Created by apple on 12/07/23.
//

import UIKit
import Alamofire

class AppointListController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var arrOfPlans : [Booking] = []
    @IBOutlet weak var txtNoData: UILabel!
   
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
   
    @IBOutlet weak var txtAppoin: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib2 = BookedAppointCell.nib
        tableView.register(nib2, forCellReuseIdentifier:BookedAppointCell.identifier)
        btnBack.setTitle(LocalisationManager.localisedString("back"), for: .normal)
        txtAppoin.text =  LocalisationManager.localisedString("appointments")
        txtNoData.text =  LocalisationManager.localisedString("appointments_empty")
        
//            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        txtNoData.isHidden = true
        
        planAPICALL()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfPlans.count
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: BookedAppointCell.identifier, for: indexPath) as! BookedAppointCell
        cell2.selectionStyle = .none
        cell2.txtName.text = arrOfPlans[indexPath.row].therapistName
        cell2.btnTime.setTitle(arrOfPlans[indexPath.row].startTime + " - " + arrOfPlans[indexPath.row].endTime, for: .normal)
        cell2.btnDate.setTitle(arrOfPlans[indexPath.row].date, for: .normal)
        
        return cell2
    }

    func planAPICALL()
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let userId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["athlete_id": userId]
        print(param)
        APIManager.shared.requestService(withURL: Constant.appointListAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(AppointListResponse.self, from: data)
                    self.arrOfPlans = model.data.booking
                 
                    if (self.arrOfPlans.count > 0)
                    {
                        self.txtNoData.isHidden = true
                        self.tableView.reloadData()
                    }
                    else
                    {
                        self.txtNoData.isHidden = false
                    }
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
