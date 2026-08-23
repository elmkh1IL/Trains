//
//  StationSelectionViewModel.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation
import Combine

@MainActor
final class StationSelectionViewModel: ObservableObject {

    @Published var searchText = ""

    private(set) var stations: [Station]

    init(city: City) {
        self.stations = city.stations
    }

    var filteredStations: [Station] {
        guard !searchText.isEmpty else {
            return stations
        }

        return stations.filter { station in
            station.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}
