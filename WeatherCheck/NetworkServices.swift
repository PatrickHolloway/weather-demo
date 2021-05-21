//
//  NetworkServices.swift
//  WeatherCheck
//
//  Created by Patrick Holloway on 5/21/21.
//

import Foundation
import Alamofire

class NetworkServices: NSObject {
	
	let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
	let apiKey = "96acaea82fce2fc52de8ed4d2ded4437"
	
	var callType = ""
	var onComplete: ((_ result: AnyObject, _ callType: String)->())?
	var onError: ((_ error: AnyObject, _ callType: String)->())?
	
	func get(callType: String, getURL: String) {
		AF.request(getURL).responseJSON { response in
			print(response)
		}
	}
	
	func getFromString(city: String) {
		self.callType = "getFromString"
		
		let getURL = "\(baseUrl)q=\(city)&appid=\(apiKey)"
		
		print(getURL)
		
		self.get(callType: self.callType, getURL: getURL)
	}
	
	func getFromZip(zip: String) {
		self.callType = "getFromZip"
	}
	
	func getFromGeo(lat: String, lon: String) {
		self.callType = "getFromGeo"
	}
}
