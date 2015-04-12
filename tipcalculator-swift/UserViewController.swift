//
//  UserViewController.swift
//  tipcalculator-swift
//
//  Created by Darlene Wong on 4/5/15.
//  Copyright (c) 2015 Darlene Wong. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var defaultTaxLabel: UILabel!
    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var defaultTaxField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Load the default values
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        
        let defaultTaxValue = defaults.floatForKey("defaultTax")
        defaultTaxLabel.text = NSString(format: "%.2f", defaultTaxValue)
        
        let defaultTipValue = defaults.floatForKey("defaultTip")
        defaultTipLabel.text = NSString(format: "%.2f", defaultTipValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didEditTip(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultTipValue = (defaultTipField.text as NSString).floatValue
        defaults.setFloat(defaultTipValue, forKey: "defaultTip")
        defaults.synchronize()
    }
    
    @IBAction func didEditTax(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultTaxValue = (defaultTaxField.text as NSString).floatValue
        defaults.setObject(defaultTaxValue, forKey: "defaultTax")
        defaults.synchronize()
    }
    
    @IBAction func didTouchDone(sender: AnyObject) {
        NSLog("didTouchDone")
        // Go back
        dismissViewControllerAnimated(true, completion: nil)
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
