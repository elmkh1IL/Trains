//
//  CarrierInfoService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfoResponse  = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse
}

final class CarrierInfoService: CarrierInfoServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse {
        
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code
        ))
        
        return try response.ok.body.json
    }
}

func testFetchCarrierInfo() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let scheduleService = ScheduleBetweenStationsService(
                client: client,
                apikey: "a02b4c80-937e-4481-9aba-3a58bd132056"
            )

            let schedule = try await scheduleService.getScheduleBetweenStations(
                fromStation: "c146",
                toStation: "c213",
                date: "2026-08-18",
                transfers: true
            )

            guard let carrierCode = schedule
                .segments?
                .first?
                .thread?
                .carrier?
                .code else {

                print("Could not find carrier code")
                return
            }

            print("Found carrier code: \(carrierCode)")

            let carrierService = CarrierInfoService(
                client: client,
                apikey: "a02b4c80-937e-4481-9aba-3a58bd132056"
            )

            let carrier = try await carrierService.getCarrierInfo(
                code: String(carrierCode)
            )

            print("Successfully fetched carrier info:")
            print(carrier)

        } catch {
            print("Error fetching carrier info: \(error)")
        }
    }
}
