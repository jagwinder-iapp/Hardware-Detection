//
//  BaseApiManager.swift
//  Metal Detector
//
//  Created by iapp on 20/03/24.
//

import Foundation
import Alamofire
import SVProgressHUD
import Alamofire


enum HTTPMethods : String{
    
    case POST = "POST"
    case GET = "GET"
    case DELETE = "DELETE"
}


class BaseApiClass {
    
    // MARK: REQUEST API
    
    final func requestBaseApi(_ parameters: [String:Any],_ url: String, _ httpMethod: HTTPMethods,_ completion: @escaping(_ :Data?, _ status: Bool, _ error: Error?)-> Void) {
        self.requestService(parameters: parameters, url: url,  httpMethod: httpMethod.rawValue) { (response, status, error) in
            completion(response, status, error)
        }
    }
    
//    final func requestEventApi(_ parameters: [String:Any],_ url: String, _ httpMethod: HTTPMethods,_ completion: @escaping(_ :Data?, _ status: Bool, _ error: Error?)-> Void) {
//        
//    }
    
    // MARK: BASE API METHOD
    
    private func requestService(parameters : Dictionary<String, Any>, url : String, httpMethod : String,_ completion: @escaping(_ :Data?, _ status: Bool, _ error: Error?)-> Void) {
        
        debugPrint("✅ Parameters ✅", parameters)
        debugPrint("🌐 URL 🌐", url)
        
        if Reachability.shared.isConnectedToNetwork{
            
            //HEADERS
            guard let serviceUrl = URL(string: url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = httpMethod
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("1a9151f252db4f188ce44bde3c8c5459", forHTTPHeaderField: "hibp-api-key")
            request.setValue("NetworkToolbox-For-iOS", forHTTPHeaderField: "user-agent")
            request.setValue("application/vnd.haveibeenpwned.v3+json", forHTTPHeaderField: "accept")
            
            //MANAGE HTTP REQUEST
            if httpMethod == HTTPMethods.POST.rawValue {
                let parameters = parameters.jsonStringRepresentation
                let postData = parameters?.data(using: .utf8)
                request.httpBody = postData
                
            }
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if data != nil {
                    guard let data = data else {
                        print(String(describing: error))
                        return
                    }
                    print(String(data: data, encoding: .utf8)!)
                }
                
                if response != nil {}
                if let data = data {
                    completion(data, true, nil)
                }else{
                    completion(nil, false, error)
                }
                
            }.resume()
        }else{
            SVProgressHUD.dismiss()
            UIApplication.topViewController()?.showNewAlert("Network Lost!", ErrorMessage.error_Internet_connectMessage, handler: nil)
            return
        }
    }
}
