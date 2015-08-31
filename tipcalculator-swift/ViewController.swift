//
//  ViewController.swift
//  tipcalculator-swift
//
//  Created by Darlene Wong on 4/4/15.
//  Copyright (c) 2015 Darlene Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UserViewControllerDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var taxStepper: UIStepper!
    @IBOutlet weak var tipStepper: UIStepper!
    @IBOutlet weak var taxSliderLabel: UILabel!
    @IBOutlet weak var tipSliderLabel: UILabel!
    var locale: String!
    
    func setDefaultRates() {
        var defaults = NSUserDefaults.standardUserDefaults()
        let defaultTaxValue = defaults.doubleForKey("defaultTax")
        let defaultTipValue = defaults.doubleForKey("defaultTip")
        self.locale = defaults.stringForKey("defaultLocale")
        
//        var formatter = NSNumberFormatter()
//        var mylocale: String
        
        println(defaultTaxValue)
        println(defaultTipValue)
        taxStepper.value = defaultTaxValue
        tipStepper.value = defaultTipValue
        
//        formatter.numberStyle = .CurrencyStyle
//        formatter.locale = NSLocale(localeIdentifier: mylocale)
//        println("mylocale " + mylocale)
        
        taxSliderLabel.text = String(format: "%.2f%%", taxStepper.value)
        tipSliderLabel.text = String(format: "%.2f%%", tipStepper.value)
        
        println("finished setting up defaults")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        
        // Do any additional setup after loading the view, typically from a nib.
        var defaults = NSUserDefaults.standardUserDefaults()
        var formatter = NSNumberFormatter()
        var mylocale: String
        if (defaults.objectForKey("defaultLocale") != nil) {
            mylocale = defaults.objectForKey("defaultLocale") as! String
        } else {
            mylocale = "en_US" // default locale
        }
        self.locale = mylocale
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: mylocale)

        taxLabel.text = formatter.stringFromNumber(0)! // "$0.00"
        tipLabel.text = formatter.stringFromNumber(0)! // "$0.00"
        totalLabel.text = formatter.stringFromNumber(0)! //"$0.00"
        setDefaultRates()
        
        updateDefaultTheme(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTotal() {
        var billAmount = (billField.text as NSString).doubleValue
        
        let taxPercentage = taxStepper.value / 100
        let tipPercentage = tipStepper.value / 100
        
        let taxAmount = billAmount * taxPercentage
        let tipAmount = billAmount * tipPercentage
        
        var total = billAmount + taxAmount + tipAmount
        
        // get the currency formatter for the locale
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        if (self.locale != nil) {
            println("updateTotal by locale " + self.locale)
            formatter.locale = NSLocale(localeIdentifier: self.locale)
        } else {
            println("updateTotal by default locale")
            formatter.locale = NSLocale(localeIdentifier: "en_US")
        }
        // fancier string formatting
        taxLabel.text = formatter.stringFromNumber(taxAmount) //String(format: "$%.2f", taxAmount)
        tipLabel.text = formatter.stringFromNumber(tipAmount) //String(format: "$%.2f", tipAmount)
        totalLabel.text = formatter.stringFromNumber(total) //String(format: "$%.2f", total)
        println("updateTotal finished")
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        println("onEditingChanged")
        setDefaultRates()
        updateTotal()
    }

    @IBAction func tipStepperChanged(sender: AnyObject) {
        tipSliderLabel.text = String(format: "%.2f%%", tipStepper.value)
        updateTotal()

    }
    @IBAction func taxStepperChanged(sender: AnyObject) {
        taxSliderLabel.text = String(format: "%.3f%%", taxStepper.value)
        updateTotal()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "settingsSegue" {
            let vc = segue.destinationViewController as! UserViewController
            vc.delegate = self
        }
    }
    
    func myVCDidFinish(controller: UserViewController) {
        // update tax and tip defaults, they may have changed in the settings
        println("myVCDidFinish")
        setDefaultRates()
        updateTotal()
        
        // update theme
        updateDefaultTheme(self)
        
//        UIView.appearance().tintColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.5)
//        UITextField.appearance().textColor = UIColor.orangeColor()
//        UILabel.appearance().textColor = UIColor.orangeColor()
//        UIButton.appearance().titleLabel?.textColor = UIColor.orangeColor()
//        
//        self.view.tintColor = UIColor.blackColor()
//        self.view.backgroundColor = UIColor.blackColor()

    }
}

