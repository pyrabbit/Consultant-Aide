//
//  STRService.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 2/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class STRService {

    let betaBaseUrl = "https://beta.shoptheroe.com/api/v2"
    let baseUrl = "https://shoptheroe.com/api/v2"
    var id: String
    var authorizeUrl: URL
    var betaId: String
    var betaAuthorizeUrl: URL
    
    init() {
        betaId = "EKBEWEHiA8S2gRrNdfYeuw8RwiECMzFlmrAmsTsM"
        id = "KPMDPQIzzDNjfTmmkXdG1ZPAai3B3TQvlbIHnUoA"
        authorizeUrl = URL(string: "https://shoptheroe.com/o/authorize/?response_type=token&client_id=\(id)&state=random_state_string&redirect_uri=consultantaide://strDidAuthorizeApp")!
        betaAuthorizeUrl = URL(string: "https://beta.shoptheroe.com/o/authorize/?response_type=token&client_id=\(betaId)&state=random_state_string&redirect_uri=consultantaide://strDidAuthorizeApp")!
    }
    
    func authorize() {
        UIApplication.shared.openURL(authorizeUrl)
    }
    
    func testAuthentication(completion: @escaping (Bool)  -> ()) {
        guard let access_token = UserDefaults.standard.value(forKey: "strAccessToken") else {
            completion(false)
            return
        }
        
        Alamofire.request("\(baseUrl)/",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(access_token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    let message = "ShopTheRoe: Failed test authentication with: \(error)"
                    Rollbar.error(withMessage: message)
                    completion(false)
                }
            }
    }
    
    func createImage(image: UIImage?, completion: @escaping (Bool, Int)  -> ()) {
        guard let image = image else {
            return
        }
        
        guard let data = UIImagePNGRepresentation(image) else {
            return
        }
        
        guard let access_token = UserDefaults.standard.value(forKey: "strAccessToken") else {
            return
        }
        
        print("ShopTheRoe: Uploading image...")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "image_full", fileName: "image.png", mimeType: "image/png")
            },
            to: "\(baseUrl)/images/",
            method: .post,
            headers: ["Authorization": "Bearer \(access_token)"],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let json):
                            let data = JSON(json)
                            
                            if let imageId = data["pk"].int {
                                print("ShopTheRoe: Successfully uploaded image with id \(imageId)")
                                completion(true, imageId)
                            }
                        case .failure(let error):
                            let message = "ShopTheRoe: Failed uploading image with error \(error)"
                            Rollbar.error(withMessage: message)
                            completion(false, 0)
                        }
                        
                    }
                case .failure(let encodingError):
                    let message = "ShopTheRoe: Failed encoding image with error \(encodingError)"
                    Rollbar.error(withMessage: message)
                    completion(false, 0)
                }
            }
        )
    }
    
    func createItem(styleId: Int, sizeId: Int, imageId: Int, completion: @escaping (Bool, Int)  -> ()) {
        guard let access_token = UserDefaults.standard.value(forKey: "strAccessToken") else {
            return
        }
        
        let parameters: [String: Any] = [
            "itemchoice_id" : styleId,
            "size_id" : sizeId,
            "image_id" : imageId
        ]
        
        print("ShopTheRoe: Uploading item...")
        Alamofire.request("\(baseUrl)/items/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(access_token)"]).responseJSON(
                completionHandler: { response in
                    switch response.result {
                    case .success(let json):
                        let data = JSON(json)
                        
                        if let itemId = data["pk"].int {
                            print("ShopTheRoe: Successfully uploaded item with id \(itemId)")
                            completion(true, itemId)
                        }
                    case .failure(let error):
                        let message = "ShopTheRoe: Failed uploading item with error \(error)"
                        Rollbar.error(withMessage: message)
                        completion(false, 0)
                    }
            })
    }
    
}
