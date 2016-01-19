//
//  LoginViewController.swift
//  AsuraIOS
//
//  Created by David on 2016/1/16.
//  Copyright © 2016年 David Lin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        let alertController_username = UIAlertController(title: "Error", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
        let alertController_password = UIAlertController(title: "Error", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
        let alertController_loginfail = UIAlertController(title: "Error", message: "Log in fail, please check username/password", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok", style: .Default) {
            (action) -> Void in print("Alert message")
        }
        
        // verify character
        if let username = username where username.characters.count < 5 {
            alertController_username.addAction(okAction)
            self.presentViewController(alertController_username, animated: true, completion: nil)                        
        } else if let password = password where password.characters.count < 8 {
            alertController_password.addAction(okAction)
            self.presentViewController(alertController_password, animated: true, completion: nil)
        } else {
            
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // send log in request
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    print("log in success")
                    self.moveViewtoHomeTab()
                } else {
                    alertController_loginfail.addAction(okAction)
                    self.presentViewController(alertController_loginfail, animated: true, completion: nil)
                    print("log in fail")
                }
            })
        }
    }
    
    //
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result:FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if(error != nil)
        {
            print(error.localizedDescription)
            return
        }
        
        if let userToken = result.token
        {
            // Login to parse through using access token
            loginFBToParseWithAccessToken(userToken)
            
            /*
            // Get user access token
            let token:FBSDKAccessToken = result.token
            print("Token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("User ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            // Insert to Pasrse
            if(PFUser.currentUser() == nil)
            {
            let newUser = PFUser()
            
            newUser.username = FBSDKAccessToken.currentAccessToken().userID
            newUser.password = FBSDKAccessToken.currentAccessToken().userID
            
            // register user by async method
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            // stop spinner
            if ((error) != nil) {
            print("\(error?.localizedDescription)")
            // Re-log in the user
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
            } else {
            print("add User to Parse")
            }
            })
            }*/
            
            // move view to tab bar after
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("user is logged out")
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
