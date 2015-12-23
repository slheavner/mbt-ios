//
//  ScheduleViewController.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/7/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

class ScheduleViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var bus = ViewController.Bus()
    var titles = ["Service Times", "First Run", "Last Run", "Run Time"]
    var content = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var lastTitle: UILabel!
    @IBOutlet weak var runTitle: UILabel!
    @IBOutlet weak var serviceText: UITextView!
    @IBOutlet weak var firstText: UITextView!
    @IBOutlet weak var lastText: UITextView!
    @IBOutlet weak var runText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "\(bus.name) Schedule"
        bus = (self.navigationController as! ScheduleNavigationController).bus
        self.navigationController?.navigationBar.topItem?.title = "\(bus.name) Schedule"
        self.content = [bus.service, bus.firstrun, bus.lastrun, bus.runtime]
        let nib = UINib(nibName: "TextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "tvcell")
        let nic = UINib(nibName: "CenteredCell", bundle: nil)
        self.tableView.registerNib(nic, forCellReuseIdentifier: "centercell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.item % 2 > 0{
            let cell:TextViewTableCell = self.tableView.dequeueReusableCellWithIdentifier("tvcell") as! TextViewTableCell
            cell.textView.text = content[indexPath.item / 2]
            if(indexPath.item >= 6 && bus.id == "prt"){
                cell.hidden = true
            }
            return cell
        }else{
            let cell:CenteredTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("centercell") as! CenteredTableViewCell
            cell.textCenter.text = titles[indexPath.item / 2]
            if(indexPath.item >= 6 && bus.id == "prt"){
                cell.hidden = true
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.item % 2 > 0{
            return 64
        }else{
            return 30
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat.max))
        var newFrame = textView.frame
        let newWidth: CGFloat = fmax(newSize.width, fixedWidth)
        newFrame.size = CGSizeMake(newWidth, newSize.height)
        textView.frame = newFrame
        
    }
    
    
}
