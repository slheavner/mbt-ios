//
//  ViewController.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/2/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//
//


//this can can control the view. for example, action for button press

import UIKit

class ViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {

    
    //weak = can break connection when we don't need it anymore
    //! at end of UILabel! means it has a value immediately. Compiler does not check it.
   
    //semicolons are okay, but frowned upon
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
    
    var busarray = [JSON]?()
    var busses = [String: Bus]()
    var json: JSON = nil
    var data = NSData()
    var selectedBus: Bus = Bus()
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Bus Status List"
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.addTarget(self, action: "getJsonBusList", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        //self.navigationController?.navigationBar.barTintColor = DataManager.hexStringToUIColor("ebebeb")
        var nib = UINib(nibName: "BusTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        nib = UINib(nibName: "NoBussesCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "nobus")
        if getDefaults().valueForKey(busIds[0]) == nil {
            for b in busIds {
                getDefaults().setBool(false, forKey: b)
            }
            getDefaults().synchronize()
        }
        var b = ""
        for i in 0...busIds.count-1 {
            b = busIds[i]
            if getDefaults().boolForKey(b) {
                let bus = Bus()
                bus.name = busNames[i]
                bus.id = busIds[i]
                bus.number = busNumbers[i]
                busses[b] = bus
            }
        }
//        for b in busIds {
//            if getDefaults().objectForKey("\(b)_object") == nil {
//                busses[b] = nil
//            }else{
//                if let bus:Bus = readBus(b) {
//                    busses[b] = bus
//                }else{
//                    busses[b] = nil
//                }
//            }
//        }
        
        self.title = "Statuses"
        startTimeThread()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if busses.count > 0 {
            selectedBus = busses[busIds[indexPath.item]]!
            self.performSegueWithIdentifier("map", sender: self)
            print("selected \(indexPath.item)")
        } else {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "map"{
            let destViewController: MapViewController = segue.destinationViewController as! MapViewController
            destViewController.bus = selectedBus
        }
    }
    
    func getJsonBusList(){
        getDefaults().synchronize()
        DataManager.getBusList{ (data) -> Void in
            if data != nil {
                self.json = JSON(data: data)
                self.populateBusses(self.json)
            }
            dispatch_async(dispatch_get_main_queue(),  {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
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
        if busses.count == 0{
            if indexPath.item == 0 {
                let cell:NoBussesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("nobus") as! NoBussesTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }else{
                let cell = UITableViewCell()
                cell.hidden = true
                return cell
            }
        }
        let cell:BusTableViewCellClass = self.tableView.dequeueReusableCellWithIdentifier("cell") as! BusTableViewCellClass
        let id = busIds[indexPath.item]
        if let bus = busses[id] {
            cell.nameText.text = bus.name
            cell.numberText.text = bus.number
            cell.statusTextView.text = bus.getBestLocation()?.desc
            cell.timeText.text = bus.getBestLocation()?.getTimeText(bus.id)
            cell.timeText.textColor = bus.getBestLocation()?.getTimeColor(cell.timeText.text!, id: bus.id)
            cell.statusTextView.selectable = false
            cell.hidden = false
        }else{
            cell.hidden = true
        }
        return cell
    }
    
    func getBusById(index: Int) -> Int{
        var i = 0
        for i = 0; i < json.count; i++ {
            if json[i]["id"].string == busIds[index]{
                return i
            }
        }
        return 0
    }
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if busses[busIds[indexPath.item]] != nil {
            return 123
        }else if busses.count == 0 && indexPath.item == 0 {
            return 185
        }else{
            return 0
        }
    }
    
    func populateBusses(json: JSON){
        //var i = 0
        for i in 0...busIds.count-1{
            for j in 0...json.count-1 {
                if json[j]["id"].string == busIds[i]{
                    let bus = Bus(bus: json[j])
//                    if bus !== readBus(bus.id) {
//                        saveBus(bus)
//                    }
                    if getDefaults().boolForKey(busIds[i]) {
                        busses[busIds[i]] = bus
                    }else{
                        busses[busIds[i]] = nil
                    }
                }
            }
        }
    }
    
    func saveBus(bus: Bus){
        let busarray = [bus]
        let data = NSKeyedArchiver.archivedDataWithRootObject(busarray)
        getDefaults().setObject(data, forKey: "\(bus.id)_object")
    }
    
    func readBus(id: String) -> Bus?{
        let data = getDefaults().objectForKey("\(id)_object") as? NSData
        if let data = data{
            let busarray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Bus]
            if let busarray = busarray {
                return busarray[0]
            }
        }
        return nil
    }
    
    class Bus: NSObject{
        var name: String
        var number: String
        var id: String
        var status: String
        var service: String
        var firstrun: String
        var lastrun: String
        var runtime: String
        var polylineColor: String
        var locations = [Location?]()
        var polyline: PolyLine
        
        
        init(bus: JSON){
            self.name = bus["name"].string!
            self.number = bus["number"].string!
            self.id = bus["id"].string!
            self.service = bus["service"].string!
            self.firstrun = bus["firstrun"].string!
            self.lastrun = bus["lastrun"].string!
            self.runtime = bus["runtime"].string!
            self.polylineColor = bus["polylineColor"].string!
            //var size = bus["locations"].count
            var tmp = bus["locations"][2]
            
            if tmp["desc"] != nil {
                self.status = tmp["desc"].string!
            }else{
                self.status = bus["locations"][0]["desc"].string!
            }
            self.polyline = PolyLine(pl: bus["polyline"])
            
            super.init()
            self.createLocations(bus)
            
        }
        override init(){
            self.name = ""
            self.status = ""
            self.id = ""
            self.number = ""
            self.service = ""
            self.polylineColor = ""
            self.polyline = PolyLine()
            self.firstrun = ""
            self.lastrun = ""
            self.runtime = ""
            super.init()
        }
        
        func createLocations(bus: JSON){
            if let locations = bus["locations"].array {
                for i in 0...locations.count-1{
                    self.locations.append(Location(loc: locations[i]))
                }
            }
        }
        
        func getBestLocation() -> Location? {
            //var loc : Location
            if self.locations.count < 1{
                return nil
            }
            if self.id == "prt" {
                return self.locations[0]
            }
            var least = -1, leastTime = -1.00
            for i in 0...self.locations.count - 1{
                if let loc = self.locations[self.locations.count - 1 - i] {
                    if least == -1 {
                        least = self.locations.count - 1 - i
                        leastTime = loc.time
                    }else if leastTime < loc.time {
                        leastTime = loc.time
                        least = self.locations.count - 1 - i
                    }
                }
            }
            if least != -1{
                return self.locations[least]
            }
            return nil
        }
        
    }
    
    class Location: NSObject{
        var desc: String
        var lat: Double
        var lon: Double
        var bus: Int
        var time: Double
        
        init(loc: JSON){
            if loc != nil && loc["desc"] != nil{
                self.desc = loc["desc"].string!
                self.lat = loc["lat"].double!
                self.lon = loc["lat"].double!
                self.bus = loc["bus"].int!
                self.time = loc["time"].double!
            }else{
                self.desc = ""
                self.lat = 0
                self.lon = 0
                self.bus = -1
                self.time = 0
            }
            super.init()
        }
        
        func getTimeColor(timeString: String, id: String) -> UIColor{
            if id == "prt"{
                if(timeString == "Running"){
                    return DataManager.hexStringToUIColor("4cd964")
                }else{
                    return DataManager.hexStringToUIColor("ff3b30")
                }
            }
            if timeString.rangeOfString("sec") == nil{
                if timeString.rangeOfString(">") == nil {
                    let colon = Array(timeString.characters)[1]
                    if colon == ":" {
                        return DataManager.hexStringToUIColor("007aff")
                    }else{
                        return DataManager.hexStringToUIColor("ff9500")
                    }
                }else{
                    return DataManager.hexStringToUIColor("ff3b30")
                }
            }else {
                    return DataManager.hexStringToUIColor("4cd964")
            }
        }
        
        func getTimeText(id: String) -> String{
            if id == "prt" {
                if self.bus == 1{
                    return "Running"
                }else {
                    return "Down"
                }
            }
            var t = (((NSDate().timeIntervalSince1970) - self.time / 1000))
            if t < 60{
                return  "\(Int(t)) sec"
            }else {
                t /= 60
                if t >= 45 {
                    return "> 45 min"
                }else{
                    var s = t - Double(Int(t))
                    s *= 60
                    if s < 10 {
                        return "\(Int(t)):0\(Int(s))"
                    }else{
                        return "\(Int(t)):\(Int(s))"
                    }
                }
            }
        }
        
    }
    
    class PolyLine: NSObject{
        var lon = [Double]()
        var lat = [Double]()
        init(pl: JSON){
            if pl != nil {
                for i in 0...pl.count-1 {
                    lat.append(pl[i]["lat"].double!)
                    lon.append(pl[i]["lon"].double!)
                }
            }
            super.init()
        }
        override init(){
            super.init()
        }
    }
    
    func startTimeThread(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(self.isViewLoaded()){
                NSThread.sleepForTimeInterval(1)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.titleView?.hidden = true
        getJsonBusList()
    }

}

