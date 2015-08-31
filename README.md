# tipcalculator-swift

This is an iOS tax and tip calculator app.

Time spent: 20 hours

Completed user stories:
  * Required: User can enter a bill amount and get a tax and tip amount added automatically, based on the current tax and tip rates set.
  * Required: User can increase the tip rate.  The tip rate can be increased/decreased in 1% increments.
  * Optional: User can increase the tax rate.  The tax rate can be increased/decreased in .25% increments.
  * Optional: User can use the Settings page to update the settings by location.  Pressing the "Use Location" button will update the currency symbol and tax rate for the current location.  NOTE: Tax rates are only available for locations within the United States.
  * Optional: User can use the Settings page to update the default tax and tip rates manually
  * Optional: User can select a dark theme to change the appearance

## Installation
1. Install the SQLite.swift module, so the app can access the tax rate database.  See https://github.com/stephencelis/SQLite.swift for more details.

`$ pod install`

2. Open tipcalculator-swift.xcworkspace in Xcode.

`open tipcalculator-swift.xcworkspace`

3. Build the tipcalculator-swift app.
