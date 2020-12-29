//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager() //var not let (so it can modify its properties)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Note: Must set the coinManager's delegate as this current class so that we can receive the notifications when the delegate methods are called.
        coinManager.delegate = self
        currencyPicker.dataSource = self //setting the ViewController class as the dataSource to the currencyPicker object
        currencyPicker.delegate = self //setting the ViewController class as the delegate of the currencyPicker
        
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateData(currency: String, bitcoinPrice: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", bitcoinPrice)
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView Delegate and DataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //returns number of components (component is column hence this returns 1 column)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count //returns number of rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row] //returns the title for a given row. When the PickerView is loading up, it will ask its delegate for a row title and call this method once for every row. So when it is trying to get the title for the first row, it will pass in a row value of 0 and a component (column) value of 0.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row]) //passing the selected currency to the CoinManager via the getCoinPrice() method
    } //This method gets called every time the user scrolls the picker. When that happens, it will record the row number that was selected.
}
