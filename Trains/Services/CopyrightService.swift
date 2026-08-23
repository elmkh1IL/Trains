//
//  CopyrightService.swift
//  Trains
//
//  Created by el on 11.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightProtocol {
    func getCopyright(format: String) async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCopyright(format: String) async throws -> CopyrightResponse {
        
        let response = try await client.getCopyright(query: .init(
            apikey: apikey,
            format: format
        ))
        
        return try response.ok.body.json
    }
}

// Функция для тестового вызова API
func testFetchCopyright() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let service = CopyrightService(
                client: client,
                apikey: APIConstants.apiKey
            )

            print("Fetching copyright...")

            let copyright = try await service.getCopyright(
                format: "json"
            )

            print("Successfully fetched copyright:")
            print(copyright)

        } catch {
            print("Error fetching copyright: \(error)")
        }
    }
}
