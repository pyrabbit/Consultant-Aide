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

    let baseUrl = "https://beta.shoptheroe.com/api/v2"
    var id: String
    
    init() {
        id = "EKBEWEHiA8S2gRrNdfYeuw8RwiECMzFlmrAmsTsM"
    }
    
    func authorize() {
        UIApplication.shared.open(URL(string: "https://beta.shoptheroe.com/o/authorize/?response_type=token&client_id=\(id)&state=random_state_string&redirect_uri=consultantaide://strDidAuthorizeApp")!)
    }
    
    func createImage(image: UIImage) {
        guard let data = UIImagePNGRepresentation(image) else {
            return
        }
        
        guard let access_token = UserDefaults.standard.value(forKey: "strAccessToken") else {
            return
        }
        
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
//                        debugPrint(response)
                        
                        switch response.result {
                        case .success(let json):
                            let data = JSON(json)
                            
                            if let imageId = data["pk"].int {
                                print("image id: \(imageId)")
                                self.createItem(styleId: 40, sizeId: 3, imageId: imageId)
                            }
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func createItem(styleId: Int, sizeId: Int, imageId: Int) {
        guard let access_token = UserDefaults.standard.value(forKey: "strAccessToken") else {
            return
        }
        
        let parameters: [String: Any] = [
            "itemchoice_id" : styleId,
            "size_id    " : sizeId,
            "image_id" : imageId
        ]
        
        Alamofire.request("\(baseUrl)/items/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ["Authorization": "Bearer \(access_token)"]).responseJSON(
                completionHandler: { response in
                    debugPrint(response)
            })
    }
    
}