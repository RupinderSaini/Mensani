//
//  PerformanceVM.swift
//  Mensani
//
//  Created by apple on 13/06/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class PerformanceVM : NSObject
{
    var reloadTableView: (() -> Void)?
    //    var notification = NotificationListResponse()
    var notificationViewModels = [DatumPerformance]() {
        didSet {
            reloadTableView?()
        }
    }
    
    func fetchData(noti: PerformanceListResponse) {
        var vms = [DatumPerformance]()
//        if noti.data.count >= 4
//        {
//            UserDefaults.standard.setValue("1", forKey: Constant.PERFORMACE_ADD)
//        }
//        else
//        {
//            UserDefaults.standard.setValue("0", forKey: Constant.PERFORMACE_ADD)
//        }
        print(noti.data.count)
        switch noti.data.count {
        case 0:
            vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 3))
            vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 2))
            vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 1))
        
    case 1:
            
            for i in noti.data.reversed() {
                vms.append(createCellModel(noti: i))
            }
                vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 2))
                vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 3))
            
        case 2:
            for i in noti.data.reversed() {
                vms.append(createCellModel(noti: i))
            }
                vms.append(DatumPerformance(performance: "  ", id: 3, sequence: 3))
               
            
            
        case 3:
            
            for i in noti.data.reversed() {
                vms.append(createCellModel(noti: i))
            }
            
            
        default:
            print(vms.count)
        }
           
        
        notificationViewModels = vms
    }
    func createCellModel(noti: DatumPerformance) -> DatumPerformance {
        let title = noti.performance
        let id = noti.id
        let seq = noti.sequence
        return DatumPerformance(performance: title, id: id, sequence: seq)
    }
    
//    var delegate: NotificationDelegate?
    
    func getCellViewModel(at indexPath: IndexPath) -> DatumPerformance {
        
        
        return notificationViewModels[indexPath.row]
    }
    
   
  
    var delegate: PerformanceDelegate?
    func sendValues(performance : String?,sequence : Int, controller : UIViewController)
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
             addAPICALL(controller: controller, performance: perform , sequence : sequence)
         }
     }
    func notiAPICALL( controller : UIViewController)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["type": "0"]
        APIManager.shared.requestService(withURL: Constant.getPerformanceAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
                    self.fetchData(noti: model)
                }
                catch {
                    print("exception")
                    print(error)
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
        let param = ["performance_id": id.description]
        APIManager.shared.requestService(withURL: Constant.deletePerformanceAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
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
    
    
    func addAPICALL( controller : UIViewController , performance : String , sequence : Int)
    {
        let apiToken = UserDefaults.standard.string(forKey: Constant.API_TOKEN)
        let header : HTTPHeaders =
        [Constant.AUTHORIZATION : apiToken!]
        print(header)
        let param = ["performance": performance , "id" : sequence.description]
        print(param)
        APIManager.shared.requestService(withURL: Constant.addPerformanceAPI, method: .post, param: param , header: header, viewController: controller) { [self] (json) in
            print(json)
            if("\(json["status"])" == "1")
            {
                do
                {
                    let data = try json.rawData(options: .prettyPrinted)
                    let model = try JSONDecoder().decode(PerformanceListResponse.self, from: data)
//                    UserDefaults.standard.set(model.da , forKey: Constant.PERFORMACE_ADD)
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
}
protocol PerformanceProtocol
{
    func sendValues( performance : String?, controller : UIViewController)
}
protocol PerformanceDelegate
{
    func sendResponse( handleString : String?)
}
