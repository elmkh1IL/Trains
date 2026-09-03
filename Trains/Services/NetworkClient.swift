//
//  NetworkClient.swift
//  Trains
//
//  Created by el on 02.09.2026.
//
import Foundation
import OpenAPIURLSession

enum NetworkClientError: LocalizedError, Sendable {

    case invalidServerURL

    var errorDescription: String? {
        "Не удалось создать адрес сервера"
    }
}
protocol NetworkClientProtocol: Sendable {
    
    func getAllStations() async throws -> AllStations
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
    
    func getRouteStations(uid: String) async throws -> RouteStationsResponse
    
    func getScheduleBetweenStations(
        fromStation: String,
        toStation: String,
        date: String,
        transfers: Bool
    ) async throws -> ScheduleBetweenStationsResponse
    
    func getStationSchedule(station: String) async throws -> StationScheduleResponse
    
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse
    
    func getCopyright(format: String) async throws -> CopyrightResponse
}

actor NetworkClient: NetworkClientProtocol {
    
    static let shared = NetworkClient()
    
    private let client: Client?
    private let apiKey: String
    
    private init() {
        if let serverURL = try? Servers.Server1.url() {
            self.client = Client(serverURL: serverURL, transport: URLSessionTransport())
        } else {
            self.client = nil
        }

        self.apiKey = APIConstants.apiKey
    }
    
    init(
        client: Client,
        apiKey: String
    ) {
        self.client = client
        self.apiKey = apiKey
    }
    
    private func requireClient() throws -> Client {
        guard let client else {
            throw NetworkClientError.invalidServerURL
        }

        return client
    }
   
    func getAllStations() async throws -> AllStations {
        let validClient = try requireClient()
        let service = AllStationsService(client: validClient, apikey: apiKey)
        
        return try await service.getAllStations()
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let validClient = try requireClient()
        let service = NearestCityService(client: validClient, apikey: apiKey)
        
        return try await service.getNearestCity(lat: lat, lng: lng)
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let validClient = try requireClient()
        let service = NearestStationsService(client: validClient, apikey: apiKey)
        
        return try await service.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    func getRouteStations(uid: String) async throws -> RouteStationsResponse {
        let validClient = try requireClient()
        let service = RouteStationsService(client: validClient, apikey: apiKey)
        
        return try await service.getRouteStations(uid: uid)
    }
    
    func getScheduleBetweenStations(
        fromStation: String,
        toStation: String,
        date: String,
        transfers: Bool
    ) async throws -> ScheduleBetweenStationsResponse {
        let validClient = try requireClient()
        let service = ScheduleBetweenStationsService(client: validClient, apikey: apiKey)
        
        return try await service.getScheduleBetweenStations(
            fromStation: fromStation,
            toStation: toStation,
            date: date,
            transfers: transfers
        )
    }
    
    func getStationSchedule(station: String) async throws -> StationScheduleResponse {
        let validClient = try requireClient()
        let service = StationScheduleService(client: validClient, apikey: apiKey)
        
        return try await service.getStationSchedule(
            station: station
        )
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfoResponse {
        let validClient = try requireClient()
        let service = CarrierInfoService(client: validClient, apikey: apiKey)
        
        return try await service.getCarrierInfo(code: code)
    }
    
    func getCopyright(format: String) async throws -> CopyrightResponse {
        let validClient = try requireClient()
        let service = CopyrightService(client: validClient, apikey: apiKey)
        
        return try await service.getCopyright(format: format)
    }
}


