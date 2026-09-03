//
//  ScheduleBetweenStationsService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime

typealias ScheduleBetweenStationsResponse = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol: Sendable {
    
    func getScheduleBetweenStations(fromStation: String, toStation: String, date: String, transfers: Bool) async throws -> ScheduleBetweenStationsResponse
}

struct ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(fromStation: String, toStation: String, date: String, transfers: Bool) async throws -> ScheduleBetweenStationsResponse {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: fromStation,
                to: toStation,
                format: "json",
                lang: "ru_RU",
                date: date,
                transfers: transfers
            )
        )
        
        return try response.ok.body.json
    }
}

