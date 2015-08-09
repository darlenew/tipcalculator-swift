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
    
    func setDefaultRates() {
        var defaults = NSUserDefaults.standardUserDefaults()
        let defaultTaxValue = defaults.doubleForKey("defaultTax")
        let defaultTipValue = defaults.doubleForKey("defaultTip")
        println(defaultTaxValue)
        println(defaultTipValue)
        taxStepper.value = defaultTaxValue
        tipStepper.value = defaultTipValue
        taxSliderLabel.text = String(format: "%.2f%%", taxStepper.value)
        tipSliderLabel.text = String(format: "%.2f%%", tipStepper.value)
        
        taxSliderLabel.text = String(format: "%.2f%%", taxStepper.value)
        tipSliderLabel.text = String(format: "%.2f%%", tipStepper.value)

        println("finished setting up defaults")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        taxLabel.text = "$0.00"
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        setDefaultRates()
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
        
        // fancier string formatting
        taxLabel.text = String(format: "$%.2f", taxAmount)
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", total)
        println("updateTotal finished")
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        // array of tip percentages
//        var tipPercentages = [0.18, 0.2, 0.22]
//        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        println("onEditingChanged")
        setDefaultRates()

        updateTotal()
    }

    @IBAction func tipStepperChanged(sender: AnyObject) {
        tipSliderLabel.text = String(format: "(%.2f)", tipStepper.value)
        updateTotal()

    }
    @IBAction func taxStepperChanged(sender: AnyObject) {
        taxSliderLabel.text = String(format: "(%.2f)", taxStepper.value)
        updateTotal()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "settingsSegue" {
            let vc = segue.destinationViewController as UserViewController
            vc.delegate = self
        }
    }
    
    func myVCDidFinish(controller: UserViewController, text: String) {
        // update tax and tip defaults, they may have changed in the settings
        setDefaultRates()
        updateTotal()
    }
}

