//
//  NetworkServices.swift
//  WeatherCheck
//
//  Created by Patrick Holloway on 5/21/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkServices: NSObject {
	
	let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
	let apiKey = "96acaea82fce2fc52de8ed4d2ded4437"
	
	var onComplete: ((_ result: AnyObject)->())?
	var onError: ((_ error: String)->())?
	
	func get(getURL: String) {
		AF.request(getURL).responseJSON { response in
			if response.error == nil {
				if let value = response.value as? NSDictionary {
					let jsonData = JSON(value)
					print(jsonData)
					
					if jsonData["cod"] != "404" {
						let weatherItem = CurrentWeather(weatherData: jsonData)
						self.onComplete?(weatherItem)
					}
					else {
						let errorMessage = jsonData["message"].stringValue.capitalized
						self.onError?(errorMessage)
					}
				}
			}
			else {
				if let error = response.error {
					print(error)
					if let errorString = error.errorDescription {
						self.onError?(errorString)
					}
				}
			}
		}
	}
	
	func getFromSearch(search: String) {
		
		var getURL = "\(baseUrl)appid=\(apiKey)&units=imperial&"
		
		// Check if search value is zip code or string
		if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: search)) {
			// Search string contains only numbers
			if search.count == 5 {
				// Check if zip code serach is correct length
				getURL = getURL + "zip=\(search)"
				
				print(getURL)
				
				self.get(getURL: getURL)
			}
			else {
				let errorMessage = "Please use a valid 5-digit zip code."
				self.onError?(errorMessage)
			}
		}
		else {
			// Note: for furture improvement, it would be good to include the list of city codes allowed by the OpenWeather API to ensure more accurate results when searching by City
			
			// Search string contains text
			if let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
				getURL = getURL + "q=\(encodedSearch)"
				
				print(getURL)
				
				self.get(getURL: getURL)
			}
		}
	}
	
	func getFromGeo(lat: String, lon: String) {
		//let getURL = "\(baseUrl)q=\(city)&appid=\(apiKey)"
		
		//print(getURL)
		
		//self.get(getURL: getURL)
	}
}
