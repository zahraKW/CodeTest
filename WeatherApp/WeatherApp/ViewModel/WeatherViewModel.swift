//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mital Khandhar on 21/09/24.
//

import Foundation
import UIKit

class WeatherViewModel: ObservableObject {
        @Published var weatherData: WeatherBase?
        
        @Published var searchText: String = "" {
            didSet {
                guard !searchText.isEmpty else { return }
                Task {
                    self.fetchWeatherData(country: "")
                }
            }
        }
        private var apiClient = APIClient()
        
        init() {
//            Task {
//                fetchWeatherData(country: country)
//            }
        }
        func fetchWeatherData(country:String,lat:String = "",log:String = ""){
           
                apiClient.getWeatherAPI(country: country,leti: lat,log: log, completion: { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            if country != ""{
                                UserDefaults.standard.setValue(country, forKey: "country")
                                UserDefaults.standard.synchronize()
                            }
                            self.weatherData = data
                           
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            
                        self.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                })
        }
        func showErrorAlert(message: String) {
            print("Error",message)
        }
    }
