//
//  WeatherViewModel.swift
//  IOSMapKitTutorial
//
//  Created by Field Employee on 6/1/21.
//  Copyright © 2021 Arthur Knopper. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var tempDescription: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tempSymbol: UIImageView!
    var nameOfCity: String?
    var unitsOfInfo: String?

    let networkManager = WeatherNetworkManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        
        // call funtion to load data
        self.loadData(city: nameOfCity!, units: unitsOfInfo!)
    }
    
    //Load JSON Data
    
    func loadData(city: String, units: String) {
            networkManager.fetchCurrentWeather(city: city, units: units) { (weather) in
                 print("Current Temperature", weather.main.temp)
                 let formatter = DateFormatter()
                 formatter.dateFormat = "dd MMM yyyy" //yyyy
                 let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
                DispatchQueue.main.async {
                    
                        self.currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                        self.tempDescription.text = weather.weather[0].description
                        self.currentTime.text = stringDate
                        if units == "imperial" {
                            self.currentTemperatureLabel.text = (String(weather.main.temp.formatTemp()) + "°F")
                            self.currentWindSpeed.text = ("Wind Speed: " + String(weather.wind.speed.formatWind()) + "mph")
                            self.currentHumidity.text = ("Humidity: " + String(weather.main.humidity) + "%")
                            self.minTemp.text = ("Min: " + String(weather.main.temp_min.formatTemp()) + "°F" )
                            self.maxTemp.text = ("Max: " + String(weather.main.temp_max.formatTemp()) + "°F" )
                        } else {
                            self.currentTemperatureLabel.text = (String(weather.main.temp.formatTemp()) + "°C")
                            self.currentWindSpeed.text = ("Wind Speed: " + String(weather.wind.speed.formatWind()) + "m/s")
                            self.currentHumidity.text = ("Humidity: " + String(weather.main.humidity) + "%")
                            self.minTemp.text = ("Min: " + String(weather.main.temp_min.formatTemp()) + "°C" )
                            self.maxTemp.text = ("Max: " + String(weather.main.temp_max.formatTemp()) + "°C" )
                        }
                        self.tempSymbol.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                        UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
                }
            }
    }
}
