//
//  SentMemesCollectionViewController.swift
//  MemeMe Assignment
//
//  Created by Christopher Crookes on 2020-07-16.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Set up the memes array to reference the memes array in the appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        setFlowLayout()
    }
    
    // MARK: - Helper Functions
    
    // Sets the flow layout for the collections view
    func setFlowLayout() {
        let space:CGFloat = 3.0
        
        // set the dimensions of the cell so we get 3 columns in portrait, or 3 rows in landscape
        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height
        let shortSize = viewWidth < viewHeight ? view.frame.size.width : view.frame.size.height
        let dimension = (shortSize - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.identifiers.sentMemeCollectionViewCell, for: indexPath) as! SentMemeCollectionViewCell
    
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memeImage
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: K.identifiers.memeDetailViewController) as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
