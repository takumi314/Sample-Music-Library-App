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
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension ViewController: UITableViewDataSource {

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
