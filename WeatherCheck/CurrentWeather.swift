//
//  CurrentWeather.swift
//  WeatherCheck
//
//  Created by Patrick Holloway on 5/23/21.
//

import Foundation
import SwiftyJSON

class CurrentWeather: NSObject {
	
	var locationName: String = ""
	var temperature: Int = 0
	var humidity: Int = 0
	var feelsLike: Int = 0
	var weatherDesc: String = ""
	var fetchTime: String = ""
		
	override init() {
		super.init()
	}
	
	init(weatherData: JSON) {
		locationName = weatherData["name"].stringValue
		temperature = weatherData["main"]["temp"].intValue
		humidity = weatherData["main"]["humidity"].intValue
		feelsLike = weatherData["main"]["feels_like"].intValue
		weatherDesc = weatherData["weather"][0]["description"].stringValue
		
		if let unixDate = weatherData["dt"].double {
			let date = Date(timeIntervalSince1970: unixDate)
			let dateFormatter = DateFormatter()
			dateFormatter.timeStyle = DateFormatter.Style.short
			dateFormatter.dateStyle = DateFormatter.Style.short
			dateFormatter.timeZone = .current
			fetchTime = dateFormatter.string(from: date)
		}
	}
}
