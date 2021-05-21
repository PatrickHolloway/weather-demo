//
//  WeatherSerachVC.swift
//  WeatherCheck
//
//  Created by Patrick Holloway on 5/21/21.
//

import Foundation
import UIKit

class WeatherSearchVC: UIViewController {
	
	let networkServices = NetworkServices()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


	@IBAction func SearchCity(_ sender: Any) {
		networkServices.getFromString(city: "Denver")
	}
}
