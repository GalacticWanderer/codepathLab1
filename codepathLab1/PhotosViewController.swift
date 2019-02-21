//
//  PhotosViewController.swift
//  codepathLab1
//
//  Created by Joy Paul on 2/15/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import AlamofireImage //for image download on cell

// utilizing a tableView hence, dataSource and delegate extensions
class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // posts is a dictionary var with String key mapped to data type Any
    var posts: [[String : Any]] = []
    
    var valueToPass: UIImage?
    
    //link to the tableView
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //setting datasource and delegate to self
        tableView.delegate = self
        tableView.dataSource = self

        //the .get request func
        getData()
    }
    
    
    //returns number of cells on the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    //configures the cell and returns it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //using a reusable cell that we set up on storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        //grabbing the elements from posts as individual post
        let post = posts[indexPath.row]
        
        if let photos = post["photos"] as? [[String: Any]]{ //[[String : Any]] list of String: Any dict
            
            let url = returnsURL(with: photos)
            
            cell.photoView.af_setImage(withURL: url)
            
        }
        
        return cell
    }
    
    
    //parses the JSON dict and returns the photo URL only
    func returnsURL(with pas_Dict: [[String:Any]]) -> URL{
        //digging deeper for the photo url
        //from posts to photos -> [x] -> orizinal size -> url
        let photo = pas_Dict[0]
        let originalSize = photo["original_size"] as! [String: Any] // [String: Any] single pair
        let urlString = originalSize["url"] as! String // exporting value of String key as String
        let url = URL(string: urlString) // turning it into an URL for Alamofire
        
        return url!
    }
    
    
    //triggers right before traveling to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let post = posts[indexPath.row]
        
        destinationVC.passedDict = post
        
    }
    
    
    //used to configure behavior of the tableView cells when tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //func to download JSON from the API
    func getData(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                //decoding JSON as a list [] of String to Any dic [String: Any]
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                //getting the 'reponse' chunk as a list of String to Any dict
                let responseDict = dataDictionary["response"] as! [String: Any]
                //print(responseDict.keys)
                
                //passing the response chunk to our [[String : Any]] dict posts as [[String : Any]]
                self.posts = responseDict["posts"] as! [[String: Any]]
                
                //print(self.posts[0]["image_permalink"] as! String)
                
                //reload tableView's data after the .get operation
                self.tableView.reloadData()
                
            }
        }
        task.resume()
    }

}
