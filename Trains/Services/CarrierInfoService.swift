//
//  CarrierInfoService.swift
//  Trains
//
//  Created by el on 13.08.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfoResponse = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol: Sendable {
    
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse
}

struct CarrierInfoService: CarrierInfoServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code))
        
        return try response.ok.body.json
    }
}
