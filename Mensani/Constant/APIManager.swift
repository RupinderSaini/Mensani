//
//  APIManager.swift
//  Mensani
//
//  Created by apple on 09/05/23.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager: NSObject {
    
    static let shared = APIManager()
    func requestService(withURL: String,method: HTTPMethod,param: [String:Any], header: HTTPHeaders? = nil , viewController:UIViewController, completionHandler: @escaping (_ result: JSON) -> Void) {
        viewController.showProgressLoader()
        print(Constant.baseURL +  withURL)
        AF.request(URL.init(string: Constant.baseURL +  withURL)!, method: method, parameters: param, encoding: JSONEncoding.default, headers: header).responseData { (response) in
//            print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.data
                    {
//                        print(json)
                        viewController.hideProgressLoader()
                            let jsonData = JSON(response.data as Any)
//                            print(jsonData)
                            if let statusCode = response.response?.statusCode {
                                if statusCode == 200 {
                                    completionHandler(jsonData)
                                } else if statusCode == 204 {
                                    completionHandler(jsonData)
                                } else {
                                    var error = jsonData["errors"].arrayValue.first?.stringValue ?? ""
                                    if error.isEmpty {
                                        error = jsonData["message"].stringValue
                                        if error.isEmpty {
                                            error = jsonData["error"].stringValue
                                        }
                                    }
                                }
                            }
                //
                                
//                        getDataFrom(JSON: response.data)
//                        successHandler((json as! [String:AnyObject]))
                    }
                    break
                case .failure(let error):
//                    failureHandler([error as Error])
                    break
                }
            }
        
        var semaphore = DispatchSemaphore (value: 0)
        var error: Error? = nil
       
       
//        task.resume()
            
        }
       
   

}
