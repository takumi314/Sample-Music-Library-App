//
//  Album.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation

struct Album {
    let title : String
    let artist : String
    let genre : String
    let coverUrl : String
    let year : String
}

extension Album: CustomStringConvertible {
    var description: String {
        return "title: \(title)" +
            " artist: \(artist)" +
            " genre: \(genre)" +
            " coverUrl: \(coverUrl)" +
        " year: \(year)"
    }
}
