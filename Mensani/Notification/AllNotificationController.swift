//
//  AllNotificationController.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import UIKit
import Alamofire

class AllNotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arrOfNoti : [DatumNoti] = []
    @IBOutlet weak var txtNoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        self.tableView.separatorStyle = .singleLine
        self.txtNoData.isHidden = true
        tableView.allowsSelection = false
        txtNoData.text =    LocalisationManager.localisedString("notifications_empty")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.black
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        if(self.currentReachabilityStatus != .notReachable)
        {
            notiAPICALL()
    }
    else
    {
        alertInternet()
    }
//        initViewModel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel.notificationViewModels.count == 0
//        {
//            txtNoData.isHidden = false
//        }
//        else
//        {
//            txtNoData.isHidden = true
//        }
//        return viewModel.notificationViewModels.count
        return arrOfNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else { fatalError("xib does not exists") }
//        let cellVM = viewModel.getCellViewModel(at: indexPath)
//               cell.cellViewModel = cellVM
        cell.txtDate.text = arrOfNoti[indexPath.row].createdAt
        cell.txtDescription.text = arrOfNoti[indexPath.row].description
        cell.txtTitle.text = arrOfNoti[indexPath.row].title
        return cell
    }
    
    
    var notificationList : [DatumNoti] = []
    var refreshControl : UIRefreshControl!
//    lazy var viewModel = {
//           NotificationVM()
//       }()
    
//    func initViewModel() {
//        if(self.currentReachabilityStatus != .notReachable)
//        {
//           viewModel.notiAPICALL(controller: self, type: "1")
//           viewModel.reloadTableView = { [weak self] in
//               DispatchQueue.main.async {
//                   self?.tableView.reloadData()
//               }
//           }
//        }
//        else
//        {
//            alertInternet()
//        }
//       }
    @objc func refresh(_ sender: Any) {
        if(self.currentReachabilityStatus != .notReachable)
        {
            notiAPICALL()
    }
    else
    {
        alertInternet()
    }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = arrOfNoti[indexPath.row].id.description
            let positio = indexPath.row
            deleteAPICALL(id: id , position: positio)
        }
    }
   

    func notiAPICALL( )
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "0"]
        APIManager.shared.requestService(withURL: Constant.notificationAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(NotificationListResponse.self, from: data)
                    self.arrOfNoti = model.data
                    print(self.arrOfNoti)
                   
                    if (self.arrOfNoti.count > 0)
                    {
                        print("count")
                        self.txtNoData.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                    else
                    {
                        print("non")
                        self.tableView.isHidden = true
                        self.txtNoData.isHidden = false
                    }
                    self.refreshControl.endRefreshing()

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
    
    
    func deleteAPICALL(id : String , position : Int)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["notification_id": id]
        APIManager.shared.requestService(withURL: Constant.notiDeleteAPI, method: .post, param: param , header: header, viewController: self) { (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    self.arrOfNoti.remove(at: position)
 
                    if (self.arrOfNoti.count > 0)
                    {
                       
                        self.txtNoData.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                    else
                    {
                        
                        self.tableView.isHidden = true
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
