//
//  HomeViewController.swift
//  AsuraIOS
//
//  Created by David Lin on 1/14/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if ((PFUser.currentUser() == nil) && (FBSDKAccessToken.currentAccessToken() == nil)) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginNav")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
        // Read more information from Facebook
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
        }

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
