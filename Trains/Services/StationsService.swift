//
//  StationsService.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation
import OpenAPIURLSession

final class StationsService: StationsServiceProtocol {
    
    static let shared = StationsService()
    
    private let allStationsService: AllStationsServiceProtocol
    
    private var cachedCities: [City]?
    
    private init() {
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        
        self.allStationsService = AllStationsService(
            client: client,
            apikey: APIConstants.apiKey
        )
    }

    init(
        allStationsService: AllStationsServiceProtocol
    ) {
        self.allStationsService = allStationsService
    }

    func getCities() async throws -> [City] {

        if let cachedCities {
            return cachedCities
        }

        let response = try await allStationsService.getAllStations()

        var cities: [City] = []

        for country in response.countries ?? [] {

            for region in country.regions ?? [] {

                for settlement in region.settlements ?? [] {

                    guard
                        let cityName = settlement.title,
                        !cityName.isEmpty
                    else {
                        continue
                    }

                    var stations: [Station] = []

                    for apiStation in settlement.stations ?? [] {

                        guard
                            let stationName = apiStation.title,
                            !stationName.isEmpty,
                            let stationCode =
                                apiStation.codes?.yandex_code,
                            !stationCode.isEmpty
                        else {
                            continue
                        }

                        let station = Station(
                            name: stationName,
                            code: stationCode
                        )

                        stations.append(station)
                    }

                    guard !stations.isEmpty else {
                        continue
                    }

                    let city = City(
                        name: cityName,
                        stations: stations
                    )

                    cities.append(city)
                }
            }
        }

        cities.sort {
            $0.name.localizedCaseInsensitiveCompare(
                $1.name
            ) == .orderedAscending
        }

        cachedCities = cities

        return cities
    }
}
