//
//  TourCollectionViewController.swift
//  AsuraIOS
//
//  Created by ChanCyrus on 1/20/16.
//  Copyright © 2016 David Lin. All rights reserved.
//

import UIKit

class TourCollectionViewController: PFQueryCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForCollection() -> PFQuery {
        // TODO: somehow the following two functions calls cannot be synchronous, making query call localstore first before calling sync
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            Tour.syncToLocalDatastore()
        })
        let query = Tour.queryFromDatastore()
        print ("run2")
        //let query = Tour.query()
        return query!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TourCell", forIndexPath: indexPath) as! TourCollectionViewCell
        
        let tour = object as! Tour
        
        //cell.tourImage.file = nil
        //if(tour.image != nil){
        cell.tourImage.file = tour.image
        cell.tourImage.loadInBackground()
        //}
        
        cell.tourName.text = tour.name
        
        return cell
    }
    
    @IBAction func addTour(sender: UIBarButtonItem) {
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
