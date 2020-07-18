//
//  SentMemesTableViewController.swift
//  MemeMe Assignment
//
//  Created by Christopher Crookes on 2020-07-16.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    // Set up the memes array to reference the memes array in the appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)

        let meme = memes[indexPath.row]
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memeImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
