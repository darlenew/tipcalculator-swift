//
//  UserViewController.swift
//  tipcalculator-swift
//
//  Created by Darlene Wong on 4/5/15.
//  Copyright (c) 2015 Darlene Wong. All rights reserved.
//

import UIKit
import CoreLocation
import SQLite

protocol UserViewControllerDelegate{
    func myVCDidFinish(controller:UserViewController, text:String)
}

class UserViewController: UIViewController, CLLocationManagerDelegate {
    var delegate:UserViewControllerDelegate? = nil
    let locationManager = CLLocationManager()
    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var defaultTaxField: UITextField!
    @IBOutlet weak var defaultCurrencySymbol: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Load the default values
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        
        let defaultTaxValue = defaults.doubleForKey("defaultTax")
        defaultTaxField.text = NSString(format: "%.2f", defaultTaxValue) as String
        
        let defaultTipValue = defaults.doubleForKey("defaultTip")
        defaultTipField.text = NSString(format: "%.2f", defaultTipValue) as String
        
//        if let defaultLocale = defaults.objectForKey("defaultLocale") as? NSLocale {
//            defaultCurrencySymbol.text = (defaultLocale.objectForKey(NSLocaleCurrencySymbol)) as! String
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didEditTip(sender: AnyObject) {
//        var defaults = NSUserDefaults.standardUserDefaults()
//        
//        let defaultTipValue = (defaultTipField.text as NSString).doubleValue
//        defaults.setDouble(defaultTipValue, forKey: "defaultTip")
//        defaults.synchronize()
//        println("Set tip to %d", defaultTipValue)
    }
    
    @IBAction func didEditTax(sender: AnyObject) {
//        var defaults = NSUserDefaults.standardUserDefaults()
//        
//        let defaultTaxValue = (defaultTaxField.text as NSString).doubleValue
//        defaults.setDouble(defaultTaxValue, forKey: "defaultTax")
//        defaults.synchronize()
//        println("Set tax to %d", defaultTaxValue)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //@IBAction func didTouchDone(sender: AnyObject) {
        //    NSLog("didTouchDone")

        var defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultTaxValue = (defaultTaxField.text as NSString).doubleValue
        defaults.setDouble(defaultTaxValue, forKey: "defaultTax")
        println("Set tax to %d", defaultTaxValue)

        let defaultTipValue = (defaultTipField.text as NSString).doubleValue
        defaults.setDouble(defaultTipValue, forKey: "defaultTip")
        println("Set tip to %d", defaultTipValue)

        let localeIdentifier = defaults.objectForKey("defaultLocale") as! String
            
        defaults.synchronize()
        if (delegate != nil) {
            println("delegate is not nil")
            delegate!.myVCDidFinish(self, text: localeIdentifier)
        } else {
            println("delegate is nil")
        }

        // Go back
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        NSLog("use location")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            NSLog("locality: " + locality)
            NSLog("postal code:" + postalCode)
            NSLog("administrativeArea: " + administrativeArea)
            NSLog("country: " + country)
            NSLog(containsPlacemark.ISOcountryCode)
        } else {
            NSLog("no placemark")
        }

    }
    
    func updateTaxRateByPlacemark(placemark: CLPlacemark?) {
        // update the default tax rate according to the placemark's zip code, if possible
        var defaults = NSUserDefaults.standardUserDefaults()

        // load the taxrate database
        let path = NSBundle.mainBundle().pathForResource("tipcalculator", ofType: "sqlite3")!
        let db = Database(path, readonly: true)
        let taxrates = db["taxrate"]
        let id = Expression<Int>("id")
        let zip = Expression<Int>("zip")
        let taxrate = Expression<Double?>("taxrate")

        // find the taxrate for this zipcode
        if let zipcode = placemark?.postalCode.toInt() {
            println(zipcode)
            let rows = taxrates.filter(zip==zipcode)
            for row in rows {
                println(row[taxrate])
                let taxValue = row[taxrate]! * 100
                let taxString = NSString(format: "%.3f", taxValue)
                // update the default tax field
                defaultTaxField.text = taxString as String
            }
        }
     }
    
    func updateCurrencySymbolByPlacemark(placemark: CLPlacemark?) {
        var defaults = NSUserDefaults.standardUserDefaults()

        if let pm = placemark {
            NSLog("Updating placemark for ISOCountryCode " + pm.ISOcountryCode)
            // maybe store ISOCountryCode in defaults
            var formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "\(pm.ISOcountryCode)")
            NSLog(formatter.stringFromNumber(14.95)!)

            // try again
            let countryCode = pm.ISOcountryCode
            let components = NSDictionary(object: countryCode, forKey: NSLocaleCountryCode)
            //let localeIdentifier = NSLocale.localeIdentifierFromComponents(components)
            let localeIdentifier = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: countryCode])
            let locale = NSLocale(localeIdentifier: localeIdentifier)
            println(locale.objectForKey(NSLocaleCurrencySymbol))
            formatter.locale = locale
            NSLog(formatter.stringFromNumber(1021.0)!)

            // store locale in defaults
            println(locale.localeIdentifier)
            defaults.setObject(locale.localeIdentifier, forKey: "defaultLocale")
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        NSLog("didUpdateLocations")
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                self.updateTaxRateByPlacemark(pm)
                self.updateCurrencySymbolByPlacemark(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
 
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)

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

