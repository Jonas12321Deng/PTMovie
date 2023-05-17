//
//  NetworkManager.swift
//  PTMovie
//
//  Created by Jons on 2023/5/17.
//

import Reachability

class NetworkManager {
    static let shared = NetworkManager()
    
    private let reachability: Reachability
    
    private init() {
        reachability = try! Reachability()
    }
    
    func startMonitoring() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Failed to start reachability notifier: \(error)")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
    
    func isConnected() -> Bool {
        return reachability.connection != .unavailable
    }
}

