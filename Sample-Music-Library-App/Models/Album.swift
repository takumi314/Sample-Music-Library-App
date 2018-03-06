//
//  Album.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation

///
/// This typealias defines a tuple which contains all of the information
/// that the table view needs to display a row of data.
///
typealias AlbumData = (title: String, valeu: String)

struct Album: Codable {
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

extension Album {
    var tableRepresentation: [AlbumData] {
        return [
            ("Title", title),
            ("Album", artist),
            ("Genre", genre),
            ("Year", year)
        ]
    }

}


