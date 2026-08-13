//
//  ScheduleBetweenStationsService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStationsResponse  = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(fromStation: String, toStation: String) async throws -> ScheduleBetweenStationsResponse
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(fromStation: String, toStation: String) async throws -> ScheduleBetweenStationsResponse {
        
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: fromStation,
            to: toStation
        ))
        
        return try response.ok.body.json
    }
}

func testFetchScheduleBetweenStations() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let service = ScheduleBetweenStationsService(
                client: client,
                apikey: "a02b4c80-937e-4481-9aba-3a58bd132056"
            )

            print("Fetching schedule between stations...")

            let schedule = try await service.getScheduleBetweenStations(
                fromStation: "c146",
                toStation: "c213"
            )

            print("Successfully fetched schedule between stations:")
            print(schedule)

        } catch {
            print("Error fetching schedule between stations: \(error)")
        }
    }
}
