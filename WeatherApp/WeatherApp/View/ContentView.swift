//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mital Khandhar on 21/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = WeatherViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    @State private var searchText: String = ""
    @State private var results: [String] = []
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                VStack(spacing: 2){
                    HStack {
                        TextField("Search City", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxHeight: 40)
                        Button(action: {
                            Task{
                                await performSearch()
                            }
                        }) {
                            Text("Search")
                            .padding()
                            .frame(maxWidth: 90)
                            .frame(maxHeight: 35)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        .frame(height: 40)
                    }
                   
                    ScrollView {
                        if !networkMonitor.isConnected {
                            Text("No internet connection.")
                                .foregroundColor(.red)
                        }
                        VStack(alignment:.leading ,spacing: 5) {
                            Text("City: \(viewModel.weatherData?.name ?? "")")
                                .font(.headline)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                            
                            Text("Weather: \(viewModel.weatherData?.weather?.first?.description ?? "")")
                                .font(.headline)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                            
                            Text(String(format: "Temp: %.2f",viewModel.weatherData?.main?.temp ?? 0.0))
                                .font(.headline)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                            
                            Text("Humidity: \(viewModel.weatherData?.main?.humidity ?? 0)% \n\n Visibility: \((viewModel.weatherData?.visibility ?? 0)/1000)km \n\n Wind Speed: \(viewModel.weatherData?.wind?.speed ?? 0.0)meter/sec \n\n Pressure: \(viewModel.weatherData?.main?.pressure ?? 00)hPa")
                                .font(.headline)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                .padding()
                
            }.background(Color.blue.opacity(0.3))
            .onChange(of: locationManager.cordinate) {newLatitude in viewModel.fetchWeatherData(country: "" ,lat: "\(locationManager.cordinate?.coordinate.latitude ?? 0.0)", log: "\(locationManager.cordinate?.coordinate.longitude ?? 0.0)")}
            .navigationTitle("Weather")
        }.onAppear {
            if let country = UserDefaults.standard.string(forKey: "country"),country != ""{
                viewModel.fetchWeatherData(country: country)
            }else{
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func performSearch() async {
         viewModel.fetchWeatherData(country: searchText)
    }
}

#Preview {
    ContentView()
}
