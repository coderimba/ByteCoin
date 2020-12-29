//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(currency: String, bitcoinPrice: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1E6B0E13-1999-41DD-AC9C-690F936F996F"
    
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","PLN","RUB","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            
            let session = URLSession(configuration: .default) //creates the browser (the thing that performs the networking)
            
            //3. Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //exit out of this function
                }
                
                if let safeData = data {
                  //  let dataAsString = String(data: safeData, encoding: .utf8) //.utf8 is a standardised protocol for encoding texts from websites
                  //  print(dataAsString)
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        self.delegate?.didUpdateData(currency: currency, bitcoinPrice: bitcoinPrice)
                    }
                }
            }
            //completionHandler will be triggered by the task; when the session completes its networking and the task is complete, the task is the one that will call the completionHandler. The completionHandler will pass those 3 arguments to the handle func so long as it has them. Effectively, we are leaving it to the task to trigger the handle function and once it does, the handle function will have access to the data, response, and error objects that the task sends over
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data) //add .self after CoinData to represent the CoinData data type (otherwise you'll be representing the CoinData object)
            
            //get the last property from the decoded data
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
