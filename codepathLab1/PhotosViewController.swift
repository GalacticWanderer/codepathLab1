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
    
    //PhotoCell
    
    var data = [URL]()

    
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
    
    //*** When using sticky headView, the indexPath.row becomes indexPath.section
    //have to use section in place for rows
    //"!!!" denotes reuired for sticky headers
    
    //!!!returns number of sections to be presented
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    
    //!!!returns number of cells each section will have.
    //Almost always it's 1, unless you want duplicates of one item or even derivatives of one item
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //!!!configures the actual headerView for the stickyView sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //add a headerView
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        //create a profile pic view
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar for profile pic view and add to subView
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel and add to subView
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 300, height: 30))
        let date = posts[section]
        label.text = date["date"] as? String
        headerView.addSubview(label)
        
        return headerView
    }
    
    //!!!returns the height for header section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    //configures the cell and returns it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //using a reusable cell that we set up on storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        //grabbing the elements from posts as individual post
        let post = posts[indexPath.section]
        
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
        
        data.append(url!)
        
        return url!
    }
    
    
    //triggers right before traveling to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let post = posts[indexPath.section]
        
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
