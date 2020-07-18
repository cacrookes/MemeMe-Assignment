//
//  MemeDetailViewController.swift
//  MemeMe Assignment
//
//  Created by Christopher Crookes on 2020-07-17.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImage.image = meme.memeImage
    }
    



}
