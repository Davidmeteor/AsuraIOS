//
//  HomeViewController.swift
//  AsuraIOS
//
//  Created by David Lin on 1/14/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tourImage: UIImageView!
    @IBOutlet weak var tourName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Do any additional setup after loading the view.
        if((PFUser.currentUser() == nil) && (FBSDKAccessToken.currentAccessToken() == nil))
        {
            // do nothing
            return
        }
        if((PFUser.currentUser() == nil) && (FBSDKAccessToken.currentAccessToken() != nil))
        {
            // Need to log in
            PFUser.logInWithUsernameInBackground(FBSDKAccessToken.currentAccessToken().userID, password: FBSDKAccessToken.currentAccessToken().userID, block: { (user, error) -> Void in
                if ((user) != nil) {
                    print("Parse User log in success")
                }
                else
                {
                    print("can't log in to Parse")
                    return
                }
            })
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // check if user is logged in already, else move to login page
        // check is done here to enhance speed of loading the app
        super.viewWillAppear(animated)
        
        if ((PFUser.currentUser() == nil) && (FBSDKAccessToken.currentAccessToken() == nil)) {
            self.moveViewToLogin()
        }
        
        //Testing purposes
        let query = PFQuery(className:"Tour")
        query.getObjectInBackgroundWithId("5CaLteld1Q"){
            (tour: PFObject?, error:NSError?) -> Void in
            if error == nil && tour != nil{
                tour!.pinInBackground()
                print("first")
                print(tour!["Name"] as! String)
                //self.tourName.text = tour!["Name"] as! String
            }
        }

        let local_query = PFQuery(className:"Tour")
        local_query.fromLocalDatastore()
        local_query.getObjectInBackgroundWithId("5CaLteld1Q"){
            (tour: PFObject?, error:NSError?) -> Void in
            if error == nil && tour != nil{
                //tour!.pinInBackground()
                self.tourName.text = tour!["Name"] as! String
                print("second")
                print(tour!["Name"] as! String)
            }
        }
        
        
        // Read more information from Facebook
        /*
        var requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        userDetails.startWithCompletionHandler{
            (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                print("testsetes")
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                
                print("\(userEmail)")
                
                // Insert to Pasrse
                if (PFUser.currentUser() == nil)
                {
                    return
                }
                
                let myUser = PFUser.currentUser()!
                
                if(userFirstName != nil)
                {
                    myUser.setObject(userFirstName!, forKey: "first_name")
                }
                if(userLastName != nil)
                {
                    myUser.setObject(userLastName!, forKey: "last_name")
                }
                if(userEmail != nil)
                {
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    let profilePictureUrl = NSURL(string: userProfile)
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    
                    if(profilePictureData != nil)
                    {
                        let profileFileObject = PFFile(data: profilePictureData!)
                        myUser.setObject(profileFileObject!, forKey: "profile_picture")
                    }
                    
                    myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                        if(success)
                        {
                            print("user details are updated to Parse")
                        }
                        
                    })
                }
            }
        }*/

    }
    
    @IBAction func addTour(sender: UIButton) {
        let newTour = Tour(name: "test")
        newTour.saveInBackground()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
