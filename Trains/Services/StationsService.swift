//
//  StationsService.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation
import OpenAPIURLSession

import Foundation

actor StationsService: StationsServiceProtocol {

    static let shared = StationsService()

    private let networkClient: any NetworkClientProtocol
    private var cachedCities: [City]?

    init(
        networkClient: any NetworkClientProtocol = NetworkClient.shared
    ) {
        self.networkClient = networkClient
    }

    func getCities() async throws -> [City] {
        if let cachedCities {
            return cachedCities
        }

        let response = try await networkClient.getAllStations()

        var cities: [City] = []

        for country in response.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    guard
                        let cityName = settlement.title, !cityName.isEmpty
                    else {
                        continue
                    }

                    var stations: [Station] = []

                    for apiStation in settlement.stations ?? [] {
                        guard
                            let stationName = apiStation.title,
                            !stationName.isEmpty,
                            let stationCode = apiStation.codes?.yandex_code,
                            !stationCode.isEmpty
                        else {
                            continue
                        }

                        stations.append(Station(name: stationName, code: stationCode))
                    }

                    guard !stations.isEmpty else {
                        continue
                    }

                    cities.append(
                        City(name: cityName, stations: stations)
                    )
                }
            }
        }

        cities.sort {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }

        cachedCities = cities

        return cities
    }
}
