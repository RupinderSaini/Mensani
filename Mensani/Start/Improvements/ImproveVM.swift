//
//  ImproveVM.swift
//  Mensani
//
//  Created by apple on 14/06/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class ImproveVM : NSObject
{
    var reloadTableView: (() -> Void)?
    //    var notification = NotificationListResponse()
    var notificationViewModels = [DatumImprovement]() {
        didSet {
            reloadTableView?()
        }
    }
    
    func fetchData(noti: ImproveListResponse) {
        var vms = [DatumImprovement]()
        
       
        for i in noti.data {
            vms.append(createCellModel(noti: i))
        }
        notificationViewModels = vms
    }
    func createCellModel(noti: DatumImprovement) -> DatumImprovement {
        let title = noti.improvement
        let id = noti.id
        return DatumImprovement(id: id, improvement: title)
    }
    
//    var delegate: NotificationDelegate?
    
    func getCellViewModel(at indexPath: IndexPath) -> DatumImprovement {
        return notificationViewModels[indexPath.row]
    }
    
    var delegate: ImproveMentDelegate?
    func sendValues(performance : String?, controller : UIViewController)
     {
         guard let perform = performance else
         {
             return
         }
       
        if perform.isEmpty
        {
            delegate?.sendResponse(handleString: StringConstant.ENTER_PERFORMANCE)
        }
         else
         {
             addAPICALL(controller: controller, performance: perform)
         }
     }
    func notiAPICALL( controller : UIViewController)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "0"]
        APIManager.shared.requestService(withURL: Constant.getImproveAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(ImproveListResponse.self, from: data)
                    self.fetchData(noti: model)
                }
                catch {
                    print("exception")
                }
            }
            else if("\(json["status"])" == "2")
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
     
    
    func deleteAPICALL( id : Int , controller : UIViewController)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["improvement_id": id.description]
        APIManager.shared.requestService(withURL: Constant.deleteImproveAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(ImproveListResponse.self, from: data)
                    self.fetchData(noti: model)
                }
                catch {
                    print("exception")
                }
            }
            else if("\(json["status"])" == "2")
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
    
    
    func addAPICALL( controller : UIViewController , performance : String)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["improvement": performance , "id" : "1"]
        
        APIManager.shared.requestService(withURL: Constant.addImproveAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(ImproveListResponse.self, from: data)
                    self.delegate?.sendResponse(handleString: "1")
                }
                catch {
                    print("exception")
                }
            }
            else if("\(json["status"])" == "2")
            {
                
            }
            
            else
            {
//                self.delegate?.sendFailure(handleString:  "\(json["message"])")
            }
            
        }
    }
}
protocol ImproveProtocol
{
    func sendValues( performance : String?, controller : UIViewController)
}
protocol ImproveMentDelegate
{
    func sendResponse( handleString : String?)
}
