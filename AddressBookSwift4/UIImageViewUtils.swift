//
//  UIImageViewUtils.swift
//  AddressBookSwift4
//
//  Created by Arnaud on 27/10/2017.
//  Copyright © 2017 Arnaud. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(url: String) {
        let urlFormat = URL(string: url)!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: urlFormat)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if(error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Status code : \(statusCode)")
                DispatchQueue.main.async() {
                    guard let data = data else {
                        return
                    }
                    self.image = UIImage(data: data)
                }
            } else {
                print(error ?? "error")
            }
        }
        task.resume()
    }
}
