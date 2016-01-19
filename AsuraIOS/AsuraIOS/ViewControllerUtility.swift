//
//  ViewControllerUtility.swift
//  AsuraIOS
//
//  Created by ChanCyrus on 1/18/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // used when user log in
    func moveViewtoHomeTab() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("mainTabBar")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    // used when user is not logged in or decide to log out
    func moveViewToLogin(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginNav")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    // for Logging in/Sign up to Parse with Facebook Token
    // It also stores data from fb(first/last name, email, profile pictures) to parse too
    func loginFBToParseWithAccessToken(userToken:FBSDKAccessToken){
        PFFacebookUtils.logInInBackgroundWithAccessToken(userToken, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    self.saveBasicInfoFromFBToParse()
                    self.moveViewtoHomeTab()
                } else {
                    print("User logged in through Facebook!")
                    self.moveViewtoHomeTab()
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }

    func saveBasicInfoFromFBToParse(){
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        userDetails.startWithCompletionHandler{
            (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
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
                
                // Insert to Parse
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
                    let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
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
}