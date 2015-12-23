//
//  ScheduleNavigationController.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/8/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

class ScheduleNavigationController: UINavigationController {

    var bus = ViewController.Bus()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue identifier = \(segue.identifier)")
    }

}
