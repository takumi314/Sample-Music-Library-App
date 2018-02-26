//
//  LibraryAPI.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/27.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import Foundation

final class LibraryAPI {

    // Singleton pattern
    static let shared = LibraryAPI()

    private let persistenceManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private var isOnline = false

    private init() {

    }

}
