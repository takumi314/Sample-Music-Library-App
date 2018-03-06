//
//  PersistencyManager.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation
import UIKit

final class PersistencyManager {

    private var albums = [Album]()
    private var cache: URL {
        get {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
    }
    private var documents: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private enum Filenames {
        static let Albums = "albums.json"
    }

    init() {
        let savedURL = documents.appendingPathComponent(Filenames.Albums)
        var data = try? Data(contentsOf: savedURL)
        if data == .none, let bundleURL = Bundle.main.url(forResource: Filenames.Albums, withExtension: nil) {
            data = try? Data(contentsOf: bundleURL)
        }

        if let albumData = data {
            let decodedAlbums = try! JSONDecoder().decode([Album].self, from: albumData)
            albums = decodedAlbums
            saveAlbums()
        }
    }

    func getAlbums() -> [Album] {
        return albums
    }

    func add(_ album: Album, at index: Int) {
        if (albums.count >= index) {
            albums.insert(album, at: index)
        } else {
            albums.append(album)
        }
    }

    func deleteAlbum(at index: Int) {
        albums.remove(at: index)
    }

    func saveImage(_ image: UIImage, fileName: String) {
        let url = cache.appendingPathComponent(fileName)
        guard let data = UIImagePNGRepresentation(image)
            else { return }
        try? data.write(to: url)
    }

    func getImage(with fileName: String) -> UIImage? {
        let url = cache.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url)
            else { return nil }
        return UIImage(data: data)
    }

    func saveAlbums() {
        let url = documents.appendingPathComponent(Filenames.Albums)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(albums)
            else { return }
        try! data.write(to: url)
    }

}
