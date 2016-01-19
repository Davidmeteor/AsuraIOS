//
//  AccountViewController.swift
//  AsuraIOS
//
//  Created by David on 2016/1/16.
//  Copyright © 2016年 David Lin. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOutAction(sender: AnyObject) {
        // log out
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        PFUser.logOut()
        
        self.moveViewToLogin()
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
