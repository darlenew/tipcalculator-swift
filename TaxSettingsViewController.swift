//
//  TaxSettingsViewController.swift
//  tipcalculator-swift
//
//  Created by Darlene Wong on 8/11/15.
//  Copyright (c) 2015 Darlene Wong. All rights reserved.
//

import UIKit

protocol TaxSettingsViewControllerDelegate{
    func didFinishTaxSettingsViewController(controller:TaxSettingsViewController, taxValue:Double)
}

class TaxSettingsViewController: UIViewController {
    var delegate:TaxSettingsViewControllerDelegate? = nil
    
    @IBOutlet weak var taxLabel: UITextField!
    @IBOutlet weak var taxStepper: UIStepper!
    var currentTaxValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Load the default values
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        currentTaxValue = defaults.doubleForKey("defaultTax")
        
        taxStepper.value = currentTaxValue
        updateTaxLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTaxLabel() {
        taxLabel.text = NSString(format: "%.2f", currentTaxValue)
    }

    func updateStepperValue() {
        taxStepper.value = currentTaxValue
    }
    
    @IBAction func didEditTax(sender: AnyObject) {
        currentTaxValue = (taxLabel.text as NSString).doubleValue
        println("done editing tax")
        updateTaxLabel()
        updateStepperValue()
    }
    
    /*
    // MARK: - Navigation

    @IBAction func didEditTaxValue(sender: AnyObject) {
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didEndOnExitTaxValue(sender: AnyObject) {
        println("did end on exit tax value")
        currentTaxValue = (taxLabel.text as NSString).doubleValue
        updateTaxLabel()
        updateStepperValue()
    }
    @IBAction func didEndEditingTaxLabel(sender: AnyObject) {
        println("did end editing tax label")
        currentTaxValue = (taxLabel.text as NSString).doubleValue
        updateTaxLabel()
        updateStepperValue()

    }
    
    @IBAction func didEditTaxValue(sender: AnyObject) {
        println("did edit tax value")
        currentTaxValue = (taxLabel.text as NSString).doubleValue
        updateTaxLabel()
        updateStepperValue()

    }
    @IBAction func valueTaxStepperChanged(sender: AnyObject) {
        println("taxStepperChanged")
        println(taxStepper.value)
        currentTaxValue = taxStepper.value
        updateTaxLabel()
    }
}
