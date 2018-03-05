//
//  ViewController.swift
//  Sample-Music-Library-App
//
//  Created by NishiokaKohei on 2018/02/26.
//  Copyright © 2018年 Kohey.Nishioka. All rights reserved.
//

import UIKit

enum Constant {
    static let CellIdentifier = "Cell"
}

final class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet var trashBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var horizontalScrollView: HorizontalScrollerView!

    // MARK: - Private properties

    var currentAlbumIndex = 0
    var currentAlbumData: [AlbumData]?
    var allAlbums = [Album]()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        allAlbums = LibraryAPI.shared.getAlbum()

        tableView.dataSource = self
        horizontalScrollView.delegate = self
        horizontalScrollView.dataSource = self
        horizontalScrollView.reload()

        showDataForAlbum(at: currentAlbumIndex)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier, for: indexPath)
        if let albumData = currentAlbumData {
            let row = indexPath.row
            cell.textLabel?.text = albumData[row].title
            cell.detailTextLabel?.text = albumData[row].valeu
        }
        return cell
    }
}

// MARK: - HorizontalScrollerViewDataSource
extension ViewController: HorizontalScrollerViewDataSource {
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
        return allAlbums.count
    }
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), coverUrl: album.coverUrl)
        if currentAlbumIndex == index {
            albumView.highlightAlbum(true)
        } else {
            albumView.highlightAlbum(false)
        }
        return albumView
    }
}

// MARK: - HorizontalScrollerViewDelegate
extension ViewController: HorizontalScrollerViewDelegate {
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
        /// grab the previously selected album, and deselect the album cover.
        let previousAlbumView = horizontalScrollView.view(at: currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(false)
        /// Store the current album cover index which is just clicked
        currentAlbumIndex = index
        /// Grab the album cover that is currently selected and highlight the selection
        let albumView = horizontalScrollView.view(at: currentAlbumIndex) as! AlbumView
        albumView.highlightAlbum(true)
        /// Display the data for the new album within the table view
        showDataForAlbum(at: currentAlbumIndex)
    }
}
