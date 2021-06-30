//
//  WeatherService.swift
//  IOSMapKitTutorial
//
//  Created by Field Employee on 5/31/21.
//  Copyright © 2021 Arthur Knopper. All rights reserved.
//
import CoreLocation
import Foundation
import UIKit
    
    class WeatherNetworkManager {
        
        func fetchCurrentWeather(city: String, units: String, completion: @escaping (WeatherModel) -> ()) {
            let formattedCity = city.replacingOccurrences(of: " ", with: "+")
            let API_URL = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&units=\(units)&appid=3a140a25cf4ee624e087992db08220be"
            
            guard let url = URL(string: API_URL) else {
                     fatalError()
                 }
                 let urlRequest = URLRequest(url: url)
                 URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                     guard let data = data else { return }
                     do {
                         let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                        completion(currentWeather)
                        print(currentWeather)
                     } catch {
                         print(error)
                     }
                         
            }.resume()
        }
        
        
    }
