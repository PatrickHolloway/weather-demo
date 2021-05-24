//
//  WeatherSerachVC.swift
//  WeatherCheck
//
//  Created by Patrick Holloway on 5/21/21.
//

import Foundation
import UIKit
import CoreLocation

class WeatherSearchVC: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var weatherBG: UIView!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var feelsLikeLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var updatedLabel: UILabel!
	
	
	let networkServices = NetworkServices()
	let locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		locationManager.delegate = self
		
		// NetworkSevices Return
		networkServices.onComplete = { result in
			
			if let currentWeather = result as? CurrentWeather {
				self.updateWeather(weather: currentWeather)
			}
			
		}
		networkServices.onError = { error in
			// Show alert view with error message
			let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
											{ action in
												self.searchBar.becomeFirstResponder()
											}))
			self.present(alert, animated: true)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.weatherBG.layer.cornerRadius = 10.0
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		searchBar.resignFirstResponder()
	}
	
	func updateWeather(weather: CurrentWeather) {
		// Set text values for weather display labels
		self.cityLabel.text = "City: \(weather.locationName)"
		self.tempLabel.text = "Current Temperature: \(weather.temperature)°"
		self.humidityLabel.text = "Humidity: \(weather.humidity)%"
		self.feelsLikeLabel.text = "Feels Like: \(weather.feelsLike)°"
		self.descLabel.text = "Weather Details: \(weather.weatherDesc)"
		self.updatedLabel.text = "Updated: \(weather.fetchTime)"
	}
	
	// UISearchBar Delegate Methods
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.showsCancelButton = true
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		searchBar.showsCancelButton = false
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		if searchBar.text != "" {
			searchBar.resignFirstResponder()
			searchBar.showsCancelButton = false
			if let searchText = searchBar.text {
				networkServices.getFromSearch(search: searchText)
			}
		}
	}
	
	// CLLocationManager Delegate Methods
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let latitude = location.coordinate.latitude
			let longitude = location.coordinate.longitude
			
			// Fetch weather for coordinates
			networkServices.getFromGeo(lat: "\(latitude)", lon: "\(longitude)")
			self.locationManager.stopUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		// Check error type...
		//let alert = UIAlertController(title: "Failed to get device location", message: "", preferredStyle: .alert)
		//alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		//self.present(alert, animated: true)
	}

	@IBAction func UseLocation(_ sender: Any) {
		// Note: May need to manually start/stop an ActivityIndicator or other loading indicator since requestLocation and the subsequent API call can feel unresponsive to the user after tapping the "Use Current Location" button.
		switch self.locationManager.authorizationStatus {
			case .authorizedAlways, .authorizedWhenInUse:
				if self.searchBar.text != "" {
					self.searchBar.text = ""
				}
				self.locationManager.requestLocation()
				break
			case .denied, .restricted:
				// Show alert view with instructions on how to enable location usage
				let alert = UIAlertController(title: "To find weather using your current location, please enable location usage in:\n Settings > Privacy > Location Services > WeatherCheck", message: "", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alert, animated: true)
				break
			case .notDetermined:
				self.locationManager.requestWhenInUseAuthorization()
				if self.searchBar.text != "" {
					self.searchBar.text = ""
				}
				self.locationManager.requestLocation()
				break
			default:
				break
		}
	}
	
}
