//
//  FullScreenPhotoViewController.swift
//  codepathLab1
//
//  Created by Joy Paul on 2/26/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    var img: UIImage!
    @IBOutlet weak var image: UIImageView!
    
    //for the scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set scrollView delegate to self
        scrollView.delegate = self
        
        image.image = img
    }
    
    //button to dismiss this view
    @IBAction func exitbutton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    //func to enable zooming combined with scrollView's attribute inspector
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    

}
