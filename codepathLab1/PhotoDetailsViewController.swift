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

    //var to store the passed JSON dict
    var passedDict: [String: Any] = [:]
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nil protection and grabbing the "photos" chunk from the passed dict
        if let photos = passedDict["photos"] as? [[String: Any]]{ //[[String : Any]] list of String: Any dict
            
            let mainVC = PhotosViewController() //an object to get access to PhotosViewController()
            
            //calling the func from the VC using our object
            let url = mainVC.returnsURL(with: photos)
            
            detailImageView.af_setImage(withURL: url)
        }
    }

}
