//
//  MapViewController.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/7/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

class MapViewController: GAITrackedViewController {
    
    
    @IBOutlet weak var infoButton: UIBarButtonItem!

    var bus: ViewController.Bus = ViewController.Bus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "\(bus.name) + Map"
        if(bus.id == ""){
            print("MAP: Bus not set")
        }
        self.navigationController?.navigationBar.topItem?.title = "Statuses"
        self.title = bus.name
        if bus.id == "prt" {
            self.title = "PRT"
        }
        
        var camera: GMSCameraPosition
        if bus.id != "prt"{
            camera = GMSCameraPosition.cameraWithLatitude(bus.polyline.lat[0], longitude: bus.polyline.lon[0], zoom: 13)
        }else{
            camera = GMSCameraPosition.cameraWithLatitude(39.647121, longitude: -79.973185, zoom: 13)
        }
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        
        if bus.id == "prt"{
            let path = GMSMutablePath()
            path.addLatitude(39.654830, longitude: -79.960229)
            path.addLatitude(39.647121, longitude: -79.973185)
            path.addLatitude(39.647592, longitude: -79.969016)
            path.addLatitude(39.634853, longitude: -79.956218)
            path.addLatitude(39.629976, longitude: -79.957220)
            let bounds = GMSCoordinateBounds(path: path)
            //var cupdate = GMSCameraUpdate.fitBounds(bounds, withPadding: 10)
            mapView.camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsetsMake(-150, -150, -150, -150))
            
            createMarker(39.654830, longitude: -79.960229, name: "Medical", map: mapView)
            createMarker(39.647121, longitude: -79.973185, name: "Evansdale", map: mapView)
            createMarker(39.647592, longitude: -79.969016, name: "Towers", map: mapView)
            createMarker(39.634853, longitude: -79.956218, name: "Beechurst", map: mapView)
            createMarker(39.629976, longitude: -79.957220, name: "Walnut", map: mapView)
            
        }else {
            let path = GMSMutablePath()
            for i in 0...bus.polyline.lat.count-1 {
                path.addLatitude(bus.polyline.lat[i], longitude: bus.polyline.lon[i])
            }
            path.addLatitude(bus.polyline.lat[0], longitude: bus.polyline.lon[0])
            let polygon = GMSPolyline(path: path)
            polygon.strokeWidth = 3
            polygon.strokeColor = UIColor.blueColor()
            let bounds = GMSCoordinateBounds(path: path)
            //var cupdate = GMSCameraUpdate.fitBounds(bounds, withPadding: 10)
            
            mapView.camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsetsMake(-150, -150, -150, -150))
            polygon.map = mapView
        }
        self.view = mapView
    }
    
    func createMarker(lat: Double, longitude: Double, name :String, map: GMSMapView){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, longitude)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.title = name
        marker.map = map
    }
    
    @IBAction func infoButtonPressed(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "schedule" {
            let dest: ScheduleNavigationController = segue.destinationViewController as! ScheduleNavigationController
            dest.bus = self.bus
        }
    }
    
}
