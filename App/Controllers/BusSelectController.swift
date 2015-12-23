//
//  BusSelectController.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/3/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

class BusSelectController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var busIds = [
        "prt",
        "mlcampuspm",
        "mlmallpm",
        "ml03green",
        "ml04orange",
        "ml06gold",
        "ml07red",
        "ml08tyrone",
        "mlpurplepink",
        "ml10brown",
        "ml11cass",
        "ml12blue",
        "ml30wr",
        "ml38bg",
        "ml44vv"]
    
    var busNames = [
        "PRT Status",
        "Campus PM",
        "Mall PM",
        "Green Line",
        "Orange Line",
        "Gold Line",
        "Red Line",
        "Tyrone",
        "Purple/Pink Lines",
        "Crown/MtHts/Graft",
        "Casville",
        "Blue Line",
        "West Run",
        "Blue/Gold",
        "Valley View"]
    
    var busNumbers = [
        "",
        "01",
        "02",
        "03",
        "04",
        "06",
        "07",
        "08",
        "9/16",
        "13/14/15",
        "11",
        "12",
        "30",
        "38",
        "44"]
    
    var busSelected = [Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Bus Selection"
        let defaults = getDefaults()
        for i in 0...busIds.count-1 {
            busSelected.append(defaults.boolForKey(busIds[i]))
        }
        let nib = UINib(nibName: "checkboxCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "checkCell")
        
        // Do any additional setup after loading the view.
    }
    
    //number sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //number rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busIds.count
    }
    
    //table contents
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:checkboxTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("checkCell") as! checkboxTableViewCell
        cell.nameText.text = busNames[indexPath.item]
        cell.numberText.text = busNumbers[indexPath.item]
        cell.busSwitch.setOn(busSelected[indexPath.item], animated: false)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:checkboxTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! checkboxTableViewCell
        cell.busSwitch.setOn(!busSelected[indexPath.item], animated: true)
        var action = ""
        if busSelected[indexPath.item] {
            action = "remove"
        }else{
            action = "add"
        }
        busSelected[indexPath.item] = !busSelected[indexPath.item]
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Bus Selection", action: action, label: busIds[indexPath.item], value: nil).build() as [NSObject : AnyObject])
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onCancelPressed(sender: UIBarButtonItem) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onDonePressed(sender: UIBarButtonItem) {
        let defaults = getDefaults()
        for i in 0...busIds.count-1{
            defaults.setBool(busSelected[i], forKey: busIds[i])
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
