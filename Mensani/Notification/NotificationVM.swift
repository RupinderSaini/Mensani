//
//  NotificationVM.swift
//  Mensani
//
//  Created by apple on 18/05/23.
//

import Foundation
import SwiftyJSON
import Alamofire


//https://www.youtube.com/watch?v=mtTx71OFKgc
class NotificationVM : NSObject
{
    
    var reloadTableView: (() -> Void)?
//    var notification = NotificationListResponse()
       var notificationViewModels = [NotificationCellViewModel]() {
           didSet {
               print("reload")
               reloadTableView?()
           }
       }
       
       func fetchData(noti: NotificationListResponse) {
           print("fetch")
           var vms = [NotificationCellViewModel]()
           notificationViewModels = vms
       }
    func createCellModel(noti: DatumNoti) -> NotificationCellViewModel {
        print("create")
            let title = noti.title
            let desc = noti.description
            let date = noti.createdAt
            let id = noti.id.description
            
            return NotificationCellViewModel(title: title, date: date, description: desc, id: id)
        }
    
//    var delegate: NotificationDelegate?
    
    func getCellViewModel(at indexPath: IndexPath) -> NotificationCellViewModel {
        print("count")
           return notificationViewModels[indexPath.row]
       }
    
    func notiAPICALL( controller : UIViewController, type : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": type]
        APIManager.shared.requestService(withURL: Constant.notificationAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(NotificationListResponse.self, from: data)
                    self.fetchData(noti: model)
                    
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


