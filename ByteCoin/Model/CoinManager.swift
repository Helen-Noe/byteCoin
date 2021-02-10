//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
	func didUpdatePrice(price: String, currency: String)
	func didFailWithError(error: Error)
}

struct CoinManager {
	
	var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8293D0C0-3660-4A83-895D-D72E63661A0D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

	func getCoinPrice(for currency: String){
		let finalURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
		performRequest(urlString: finalURL, currency: currency)
	}
	
	func performRequest (urlString: String, currency: String){
		if let url = URL(string: urlString){
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url){ (data, response, error) in
					if error != nil{
//						print(error!)
						self.delegate?.didFailWithError(error: error!)
						return
					}
					
//				let dataAsString = String(data: data!, encoding: .utf8)
//				print(dataAsString!)
				
				if let safeData = data{
					if let rate = self.parseJSON(safeData){
						let rateString = String(format: "%.2f", rate)
//						print(rate)
						delegate?.didUpdatePrice(price: rateString, currency: currency)
					}
				}
			}
			task.resume()
		}
	}
	
	func parseJSON(_ coinData: Data) -> Double?{
		let decoder = JSONDecoder()
		do{
			let decodedData = try decoder.decode(CoinData.self, from: coinData)
			let rate = decodedData.rate
//			print(rate)
			return rate
		}
		catch{
			return nil
		}
	}
		
}
