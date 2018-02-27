//
//  ViewController.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/26.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet var trashBarButtonItem: UIBarButtonItem!

    // MARK: - Private properties

    var currentAlbumIndex = 0
    var currentAlbumData: [AlbumData]?
    var allAlbums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()

        allAlbums = LibraryAPI.shared.getAlbum()

        tableView.dataSource = self
    }

    // MARK: - Private method

    func showDataForAlbum(at index: Int) {
        // defensive code: make sure the requested index is lower than the amount of albums
        if -1 < index && index < allAlbums.count {
            // fetch the album
            let album = allAlbums[index]
            // save the albums data to present it later in the tableview
            currentAlbumData = album.tableRepresentation
        } else {
            currentAlbumData = nil
        }
        // we have the data we need, let's refresh our tableview
        tableView.reloadData()
    }

}

/*:

 Delegation, is a mechanism in which one object acts on behalf of,
 or in coordination with, another object.

 */

extension ViewController: UITableViewDataSource {

    /// the number of rows to display in the table view,
    /// which matches the number of items in the “decorated” representation of the album.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albums = currentAlbumData else {
            return 0
        }
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let albumData = currentAlbumData {
            let row = indexPath.row
            cell.textLabel?.text = albumData[row].title
            cell.detailTextLabel?.text = albumData[row].valeu
        }
        return cell
    }

}
