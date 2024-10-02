//
//  NetworkUtility.swift
//  WeatherApp
//
//  Created by Mital Khandhar on 21/09/24.
//

import Foundation
import Network
import Combine

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isConnected: Bool = false
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
