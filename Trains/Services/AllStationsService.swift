//
//  AllStationsService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: AllStationsServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
        
        let response = try await client.getAllStations(
            query: .init(
                apikey: apikey
            )
        )
        
        let responseBody = try response.ok.body
        
        switch responseBody {
        case .text_html_charset_utf_hyphen_8(let body):
            
            let limit = 50 * 1024 * 1024 // 50 MB
            
            let fullData = try await Data(
                collecting: body,
                upTo: limit
            )
            
            let allStations = try JSONDecoder().decode(
                AllStations.self,
                from: fullData
            )
            
            return allStations
        }
    }
}

func testFetchAllStations() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let service = AllStationsService(
                client: client,
                apikey: "a02b4c80-937e-4481-9aba-3a58bd132056"
            )

            print("Fetching all stations...")

            let stations = try await service.getAllStations()

            print("Successfully fetched all stations:")
            print(stations)

        } catch {
            print("Error fetching all stations: \(error)")
        }
    }
}
