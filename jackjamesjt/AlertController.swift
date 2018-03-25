//
//  AlertController.swift
//  jackjamesjt
//
//  Created by Richard James Childress on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit
import CoreLocation
//import "SafeTrek.swift"

class AlertController: UIViewController, CLLocationManagerDelegate {
    
    var finalText:String!
    let safeTrekAPI = SafeTrekAPI()

    // Alert Button Has Been Pressed
    @IBAction func alertButton(_ sender: UIButton) {
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                /* Yes, only when our app is in use  */
                createLocationManager(startImmediately: true)
            case .denied:
                /* No */
                displayAlertWithTitle(title: "Not Determined",
                                      message: "Location services are not allowed for this app")
            case .notDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                /* Restrictions have been applied, we have no access
                 to location services */
                displayAlertWithTitle(title: "Restricted",
                                      message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            print("Location services are not enabled")
        }
        print( latitude, " and ", longitude )
        alertedPolice = PoliceBox.isChecked
        alertedMedical = MedicalBox.isChecked
        alertedFire = FireBox.isChecked
//        print( vc.dispFire, vc.dispMedical, vc.dispPolice )
        safeTrekAPI.createAlarm(police: PoliceBox.isChecked, fire: FireBox.isChecked, medical: MedicalBox.isChecked, lat: latitude, lon: longitude, callback: stupid)
        
        if ( (FireBox.isChecked || MedicalBox.isChecked || PoliceBox.isChecked) && latitude != nil && longitude != nil ) {
            let alert = UIAlertController(title: "Alert Sent", message: "Your alert has been sent. Send another alert to update your location.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else if ( !FireBox.isChecked && !MedicalBox.isChecked && !PoliceBox.isChecked ) {
            let alert = UIAlertController(title: "No Alert Sent", message: "You need to check a box before an alert can be sent.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "No Alert Sent", message: "Sorry, please try again or make sure Location Services are enabled.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    
    func stupid () -> String { return "" }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        // Code here is called on an error - no edits needed.
        print("Location manager failed with error = \(error)")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Code here is called when authoization changes - no edits needed.
        print("The authorization status of location services is changed to: ", terminator: "")
        
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            print("Authorized")
        case .authorizedWhenInUse:
            print("Authorized when in use")
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        }
        
    }
    
    func displayAlertWithTitle(title: String, message: String){
        // Helper function for displaying dialog windows - no edits needed.
        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
        
        present(controller, animated: true, completion: nil)
        
    }
    
    // Determines Location
    var locationManager:CLLocationManager?
    
    var latitude : Double!
    var longitude : Double!
    
    func createLocationManager( startImmediately: Bool ) {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
    }
    
    
    @IBOutlet weak var FireBox: CheckBox!
    
    @IBOutlet weak var MedicalBox: CheckBox!
    
    @IBOutlet weak var PoliceBox: CheckBox!
    
    var alertedPolice = false
    var alertedMedical = false
    var alertedFire = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear( _ animated: Bool ) {
        super.viewDidAppear( animated )
        createLocationManager(startImmediately: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
