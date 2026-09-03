//
//  StationScheduleService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

import OpenAPIRuntime

typealias StationScheduleResponse = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol: Sendable {

    func getStationSchedule(station: String) async throws -> StationScheduleResponse
}

struct StationScheduleService: StationScheduleServiceProtocol {

    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String
    ) {
        self.client = client
        self.apikey = apikey
    }

    func getStationSchedule(station: String) async throws -> StationScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apikey,
                station: station
            )
        )

        return try response.ok.body.json
    }
}

func testFetchStationSchedule() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let service = StationScheduleService(client: client, apikey: APIConstants.apiKey)

            print("Fetching station schedule...")

            let schedule = try await service.getStationSchedule(station: "s9600213")

            print("Successfully fetched station schedule:")
            print(schedule)

        } catch {
            print("Error fetching station schedule: \(error)")
        }
    }
}
