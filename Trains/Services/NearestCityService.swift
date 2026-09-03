//
//  NearestCityService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//
import OpenAPIRuntime

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol: Sendable {
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse
}

struct NearestCityService: NearestCityServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apikey,
                lat: lat,
                lng: lng
            )
        )
        
        return try response.ok.body.json
    }
}
