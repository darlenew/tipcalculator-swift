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
    func myVCDidFinish(controller:UserViewController)
}

class UserViewController: UIViewController, CLLocationManagerDelegate {
    var delegate:UserViewControllerDelegate? = nil
    let locationManager = CLLocationManager()
    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var defaultTaxField: UITextField!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var taxRateLabel: UILabel!
    @IBOutlet weak var tipRateLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var currencySymbolField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Load the default values
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        
        let defaultTaxValue = defaults.doubleForKey("defaultTax")
        defaultTaxField.text = NSString(format: "%.3f%%", defaultTaxValue) as String
        
        let defaultTipValue = defaults.doubleForKey("defaultTip")
        defaultTipField.text = NSString(format: "%.2f%%", defaultTipValue) as String
        
        if let defaultLocale = defaults.stringForKey("defaultLocale") {
            let locale = NSLocale(localeIdentifier: defaultLocale)
            currencySymbol.text = locale.objectForKey(NSLocaleCurrencySymbol) as? String
        }

        if let defaultTheme = defaults.stringForKey("defaultTheme") {
            if defaultTheme == "sfo" {
               darkThemeSwitch.on = true
            } else {
                darkThemeSwitch.on = false
            }
        }
        updateDefaultTheme(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func darkThemeSwitchChanged(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        var foreground: UIColor
        
        if darkThemeSwitch.on {
            defaults.setObject("sfo", forKey: "defaultTheme")
            updateTheme(self, "sfo")
            foreground = UIColor.orangeColor()
        } else {
            defaults.setObject("oak", forKey: "defaultTheme")
            updateTheme(self, "oak")
            foreground = UIColor.greenColor()
        }
        defaults.synchronize()
        locationButton.titleLabel?.textColor = foreground
        locationButton.setTitleColor(foreground, forState: .Normal)
        currencySymbolLabel.textColor = foreground
        currencySymbol.textColor = foreground
        taxRateLabel.textColor = foreground
        defaultTaxField.textColor = foreground
        tipRateLabel.textColor = foreground
        defaultTipField.textColor = foreground
        darkThemeLabel.textColor = foreground
        
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        //@IBAction func didTouchDone(sender: AnyObject) {
        //    NSLog("didTouchDone")

        var defaults = NSUserDefaults.standardUserDefaults()
        
        // set default tax
        let defaultTaxValue = (defaultTaxField.text as NSString).doubleValue
        defaults.setDouble(defaultTaxValue, forKey: "defaultTax")
        println("Set tax to %d", defaultTaxValue)

        // set default tip
        let defaultTipValue = (defaultTipField.text as NSString).doubleValue
        defaults.setDouble(defaultTipValue, forKey: "defaultTip")
        println("Set tip to %d", defaultTipValue)

        defaults.synchronize()
        if (delegate != nil) {
            delegate!.myVCDidFinish(self)
        }
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
        // TODO: switch to json table, this database is overkill
        let path = NSBundle.mainBundle().pathForResource("tipcalculator", ofType: "sqlite3")!
        let db = Database(path, readonly: true)
        let taxrates = db["taxrate"]
        let id = Expression<Int>("id")
        let zip = Expression<Int>("zip")
        let taxrate = Expression<Double?>("taxrate")

        println(placemark?.postalCode)
        println(placemark?.ISOcountryCode)
        
        if (placemark!.ISOcountryCode == "US") {
            // find the taxrate for this zipcode
            if let zipcode = placemark?.postalCode {
                let rows = taxrates.filter(zip==zipcode.toInt()!)
                for row in rows {
                    let taxValue = row[taxrate]! * 100
                    let taxString = NSString(format: "%.3f%%", taxValue)
                    // update the default tax field
                    defaultTaxField.text = taxString as String
                }
            }
        } else {
            defaultTaxField.text = NSString(format: "%.3f%%", 0) as String
        }
     }
    
    func updateCurrencySymbolByPlacemark(placemark: CLPlacemark?) {
        var defaults = NSUserDefaults.standardUserDefaults()

        if let pm = placemark {
            NSLog("Updating placemark for ISOCountryCode " + pm.ISOcountryCode)
            let countryCode = pm.ISOcountryCode
            let localeIdentifier = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: countryCode])
            let locale = NSLocale(localeIdentifier: localeIdentifier)

            // store locale in defaults and update displayed currency symbol
            println(locale.localeIdentifier)
            defaults.setObject(locale.localeIdentifier, forKey: "defaultLocale")
            currencySymbol.text = locale.objectForKey(NSLocaleCurrencySymbol) as? String
        }
    }
    
    // TODO use a map to select location to override the current location
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

