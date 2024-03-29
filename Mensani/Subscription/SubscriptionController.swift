//
//  SubscriptionController.swift
//  Mensani
//
//  Created by apple on 28/06/23.
//

import UIKit
import Alamofire

class SubscriptionController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var txtNoData: UILabel!
    @IBOutlet weak var tableview: UITableView!
   
    var subId = ""
    var arrOfPlans : [DatumPlan] = []
    @IBAction func btnbavk(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var txtSubP: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.setTitle(LocalisationManager.localisedString("blank"), for: .normal)
        txtNoData.text =  LocalisationManager.localisedString("no_data")
        txtSubP.text = LocalisationManager.localisedString("subs_plans")
        
        let nib2 = SubscriptionCell.nib
        tableview.register(nib2, forCellReuseIdentifier:SubscriptionCell.identifier)

//            tableView.register(SelfTalkCell.nib, forCellReuseIdentifier: SelfTalkCell.identifier)
        tableview.delegate = self
        tableview.dataSource = self
        txtNoData.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.currentReachabilityStatus != .notReachable)
        {
       planAPICALL()
}
        else
        {
            self.alertInternet()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: SubscriptionCell.identifier, for: indexPath) as! SubscriptionCell
        cell2.selectionStyle = .none
        cell2.txtName.text = arrOfPlans[indexPath.row].name
        cell2.txtDescription.text = arrOfPlans[indexPath.row].description
        cell2.txtPrice.text =  "$" + arrOfPlans[indexPath.row].price
        cell2.btnCancel.isHidden = true
        cell2.btnDuration.setTitle(arrOfPlans[indexPath.row].duration, for: .normal)
//        cell2.btnDuration.setTitle("fhcgvb", for: .normal)
        if subId == arrOfPlans[indexPath.row].id.description
        {
            cell2.viewUi.layer.borderWidth = 3
            cell2.viewUi.layer.borderColor =  #colorLiteral(red: 0.2118987441, green: 0.489084959, blue: 0.3492208123, alpha: 1)
            cell2.btnSubscribed.isHidden = false
            cell2.btnCancel.isHidden = false
            cell2.btnCancel.tag = indexPath.row
            cell2.btnCancel.addTarget(self, action: #selector(cancelOrder(_:)), for: .touchUpInside)
        }
       
        return cell2
    }
    @objc func cancelOrder(_ sender: UIButton) {
        let position = sender.tag
        if(self.currentReachabilityStatus != .notReachable)
        {
            alertUIDelete(stId: self.arrOfPlans[position].id.description, position: position)
        }
        else
        {
            self.alertInternet()
        }
       
    }
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(subId)
    if subId.isEmpty || subId == "0" || subId == "null"
    {
        if(self.currentReachabilityStatus != .notReachable)
        {
            let subId = arrOfPlans[indexPath.row].id
            let subPrice = arrOfPlans[indexPath.row].price
            let userId = UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "web") as? WebViewController
            vc?.callFrom = 1
            let lang = LocalData.getLanguage(LocalData.language)
            vc?.url = "\(Constant.baseURL)stripe/\(userId!)/\(subId)/\(subPrice)/\(lang)"
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            alertInternet()
        }
    }
    else
    {
        alertFailure(title: StringConstant.SUBS, Message: StringConstant.SUBS_ALREADY)
    }
}
    func alertUIDelete(stId : String, position : Int) -> Void
    {
        
        let refreshAlert = UIAlertController(title: LocalisationManager.localisedString("del_subs"), message: LocalisationManager.localisedString("del_subs_desc"), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("no"), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: LocalisationManager.localisedString("yes"), style: .default, handler: { (action: UIAlertAction!) in
            if(self.currentReachabilityStatus != .notReachable)
            {
                self.deleteProductAPI(stId: stId, position: position)
            }
            else
            {
                self.alertInternet()
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func deleteProductAPI(stId : String, position : Int)
    {
        let strToken =  UserDefaults.standard.string(forKey: Constant.API_TOKEN)!
        let strId =  UserDefaults.standard.string(forKey: Constant.USER_UNIQUE_ID)!
        let headers: HTTPHeaders =
            [Constant.ACCEPT : Constant.APP_JSON,Constant.AUTHORIZATION: strToken]
        print(headers)
        let lang = LocalData.getLanguage(LocalData.language)
        let param  = ["athletes_id": strId,"lang" : lang]
       
        print(param)
        APIManager.shared.requestService(withURL: Constant.cancelSubscriptionAPI, method: .post, param: param,header:  headers , viewController: self) { (json) in
         print(json)
            if("\(json["status"])" == "1")
            {
                UserDefaults.standard.set("0", forKey: Constant.SUBSCRIPTION_ID)
                self.alertSucces(title: LocalisationManager.localisedString("subs_plans"), Message: "\(json["message"])")

                    self.tableview.reloadData()

            }
            
            else{
                
//                self.txtNoData.isHidden = false
            }
        }
    }
    func planAPICALL( )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let lang = LocalData.getLanguage(LocalData.language)

        let param = ["lang": lang]
        APIManager.shared.requestService(withURL: Constant.subscriptionAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(SubscriptionListResponse.self, from: data)
                    self.arrOfPlans = model.data
                    self.subId = model.subscriptionID
                    UserDefaults.standard.set(self.subId, forKey: Constant.SUBSCRIPTION_ID)
                    if (self.arrOfPlans.count > 0)
                    {
                        self.txtNoData.isHidden = true
                        self.tableview.reloadData()
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
