//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
	func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinModel)
	func didFailWithError(error: Error)
}

struct CoinManager {
	
	var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8293D0C0-3660-4A83-895D-D72E63661A0D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

	func getCoinPrice(for currency: String){
		let finalURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
		performRequest(urlString: finalURL)
	}
	
	func performRequest (urlString: String){
		if let url = URL(string: urlString){
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url){
				(data, response, error) in
					if error != nil{
						delegate?.didFailWithError(error: error!)
						return
					}
					
					if let safeData = data{
						if let weather  = parseJSON(safeData){
							delegate?.didUpdateWeather(self, weather: weather)
						}
					}
			}
		}
		
	}
    
}
