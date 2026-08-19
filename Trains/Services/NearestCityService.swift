//
//  NearestCityService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse
}

final class NearestCityService: NearestCityServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng
        ))
        
        return try response.ok.body.json
    }
}

func testFetchNearestCity() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let service = NearestCityService(
                client: client,
                apikey: APIConstants.apiKey
            )

            print("Fetching nearest city...")

            let city = try await service.getNearestCity(
                lat: 59.864177,
                lng: 30.319163
            )

            print("Successfully fetched nearest city:")
            print(city)

        } catch {
            print("Error fetching nearest city: \(error)")
        }
    }
}
