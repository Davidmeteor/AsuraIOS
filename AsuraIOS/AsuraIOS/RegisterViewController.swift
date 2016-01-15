//
//  RegisterViewController.swift
//  AsuraIOS
//
//  Created by David Lin on 1/14/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpAction(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let alertController_username = UIAlertController(title: "Error", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
        let alertController_password = UIAlertController(title: "Error", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
        let alertController_email = UIAlertController(title: "Error", message: "Please enter a valid email address", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok", style: .Default) {
            (action) -> Void in print("Alert message")
        }
        
        // verify input
        if let username = username where username.characters.count < 5 {
            alertController_username.addAction(okAction)
            self.presentViewController(alertController_username, animated: true, completion: nil)
            
        } else if let password = password where password.characters.count < 8 {
            alertController_password.addAction(okAction)
            self.presentViewController(alertController_password, animated: true, completion: nil)
            
        } else if let email = email where email.characters.count < 8 {
            alertController_email.addAction(okAction)
            self.presentViewController(alertController_email, animated: true, completion: nil)
            
        } else {
            // spinner
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            
            // register user by async method
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // stop spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alertController_signup_fail = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    alertController_signup_fail.addAction(okAction)
                    self.presentViewController(alertController_signup_fail, animated: true, completion: nil)
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }

}
