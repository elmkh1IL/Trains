//
//  RouteStationsService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStationsResponse = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol: Sendable {
    
    func getRouteStations(uid: String) async throws -> RouteStationsResponse
}

struct RouteStationsService: RouteStationsServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String) async throws -> RouteStationsResponse {
        let response = try await client.getRouteStations(
            query: .init(
                apikey: apikey,
                uid: uid
            )
        )
        
        return try response.ok.body.json
    }
}

func testFetchRouteStations() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let scheduleService = ScheduleBetweenStationsService(
                client: client,
                apikey: APIConstants.apiKey
            )
            
            let schedule = try await scheduleService.getScheduleBetweenStations(
                fromStation: "c146",
                toStation: "c213",
                date: "2026-08-18",
                transfers: true
                
            )
            
            guard let uid = schedule.segments?.first?.thread?.uid else {
                print("Could not find route uid")
                return
            }
            
            print("Found uid: \(uid)")
            
            let routeService = RouteStationsService(
                client: client,
                apikey: APIConstants.apiKey
            )
            
            let route = try await routeService.getRouteStations(uid: uid)
            
            print("Successfully fetched route stations:")
            print(route)
            
        } catch {
            print("Error fetching route stations: \(error)")
        }
    }
}
