//
//  Tour.swift
//  AsuraIOS
//
//  Created by ChanCyrus on 1/20/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import Foundation

class Tour: PFObject, PFSubclassing {
    @NSManaged var image: PFFile?
    //@NSManaged var user: PFUser
    @NSManaged var name: String
    
    // NSObject
    // register Subclass once so Parse knows the class
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // PFSubclassing Protocol
    class func parseClassName() -> String {
        return "Tour"
    }
    
    // PFSubclassing Protocol
    override class func query() -> PFQuery? {
        let query = PFQuery(className: self.parseClassName()) //1
        //query.includeKey("user") //2
        //query.fromLocalDatastore()
        query.orderByDescending("createdAt") //3
        return query
    }
    
    class func syncToLocalDatastore(){
        self.query()?.findObjectsInBackgroundWithBlock(){
            (tours: [PFObject]?, error:NSError?) -> Void in
            if error == nil && tours != nil{
                PFObject.pinAllInBackground(tours)
                print("run")
            }
        
        }
    }
    class func queryFromDatastore() -> PFQuery? {
        let query = PFQuery(className: self.parseClassName())
        query.fromLocalDatastore()
        query.orderByDescending("createdAt")
        return query
    }
    
    //Constructor
    init(/*image: PFFile, user: PFUser, */name: String) {
        super.init()
        
        //self.image = image
        //self.user = user
        self.name = name
    }
    
    override init() {
        super.init()
    }
}