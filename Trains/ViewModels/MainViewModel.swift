//
//  MainViewModel.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published
    private(set) var fromPoint: RoutePoint?
    
    @Published
    private(set) var toPoint: RoutePoint?
    
    var fromStation: String {
        fromPoint?.displayTitle ?? ""
    }
    
    var toStation: String {
        toPoint?.displayTitle ?? ""
    }
    
    var canSearch: Bool {
        !fromStation.isEmpty && !toStation.isEmpty
    }

    func selectStation(
        city: City,
        station: Station,
        direction: SelectionDirection
    ) {
        let point = RoutePoint(
            cityName: city.name,
            station: station
        )
        
        switch direction {
        case .from:
            fromPoint = point
            
        case .to:
            toPoint = point
        }
    }
    
    func swapStations() {
        let temporaryPoint = fromPoint
        
        fromPoint = toPoint
        toPoint = temporaryPoint
    }
}
