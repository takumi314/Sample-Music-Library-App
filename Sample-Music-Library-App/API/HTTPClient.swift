//
//  HTTPClient.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation

class HTTPClient {

    @discardableResult func getRequest(_ url: String) -> AnyObject {
        return Data() as AnyObject
    }

    @discardableResult func postRequest(_ url: String, body: String) -> AnyObject {
        return Data() as AnyObject
    }

    func downloadImage(_ url: String) -> UIImage? {
        let aUrl = URL(string: url)
        guard let data = try? Data(contentsOf: aUrl!),
            let image = UIImage(data: data) else {
                return nil
        }
        return image
    }

}
