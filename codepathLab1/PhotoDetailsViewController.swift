//
//  PhotoDetailsViewController.swift
//  codepathLab1
//
//  Created by Joy Paul on 2/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoDetailsViewController: UIViewController {

    var image: UIImage!
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailImageView.image = image
    }

}
