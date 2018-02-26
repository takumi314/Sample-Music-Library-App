//
//  LibraryAPI.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation

/*:
 The Facade design pattern provides a single interface to a complex subsystem.
 One simple unified API is exposed instead of being exposed to a set of classes and the APIs.
 The user of the API is completely unaware of the complexity that lies beneath.
 This pattern is ideal when working with a large number of classes, particularly
 when they are complicated to use or difficult to understand.

 The Facade pattern decouples the code that uses the system from the interface
 and implementation of the classes you’re hiding; it also reduces dependencies
 of outside code on the inner workings of your subsystem. This is also useful
 if the classes under the facade are likely to change, as the facade class can
 retain the same API while things change behind the scenes. For example, if the day
 comes when you want to replace your backend service, you won’t have to change
 the code that uses your API, just the code inside your Facade
 */

final class LibraryAPI {

    // Singleton pattern
    static let shared = LibraryAPI()

    private let persistenceManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private var isOnline = false

    private init() {

    }

    func getAlbum() -> [Album] {
        return persistenceManager.getAlbums()
    }

    func addAlbum(_ album: Album, at index: Int) {
        persistenceManager.add(album, at: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }

    func deleteAlbum(at index: Int) {
        persistenceManager.deleteAlbum(at: index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }

}
