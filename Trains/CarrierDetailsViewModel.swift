//
//  CarrierDetailsViewModel.swift
//  Trains
//
//  Created by el on 28.08.2026.
//
import Foundation
import Combine

@MainActor
final class CarrierDetailsViewModel: ObservableObject {
    
    @Published
    private(set) var carrierInfo: CarrierInfoResponse?
    
    @Published
    private(set) var isLoading = false
    
    @Published
    private(set) var errorMessage: String?
    
    private let carrier: Carrier
    private let networkClient: any NetworkClientProtocol
    
    init(
        carrier: Carrier,
        networkClient: any NetworkClientProtocol = NetworkClient.shared
    ) {
        self.carrier = carrier
        self.networkClient = networkClient
    }
    
    var name: String {
        carrierInfo?.carrier?.title ?? carrier.name
    }
    
    var email: String {
        guard let email = carrierInfo?.carrier?.email, !email.isEmpty else {
            return isLoading ? "Загрузка..." : "Нет данных"
        }
        
        return email
    }
    
    var phone: String {
        guard let phone = carrierInfo?.carrier?.phone, !phone.isEmpty else {
            return isLoading ? "Загрузка..." : "Нет данных"
        }
        
        return phone
    }
    
    var logoURL: URL? {
        guard let logo = carrierInfo?.carrier?.logo, !logo.isEmpty else {
            return carrier.logoURL
        }
        
        if logo.hasPrefix("//") {
            return URL(string: "https:" + logo)
        }
        
        return URL(string: logo)
    }
    
    func loadCarrierInfo() async {
        
        guard carrierInfo == nil, !isLoading else {
                    return
                }
        
        guard let code = carrier.code else {
            errorMessage = "Не найден код перевозчика"
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let info = try await networkClient.getCarrierInfo(code: String(code))
            try Task.checkCancellation()
            
            carrierInfo = info
            errorMessage = nil
            
        } catch is CancellationError  {
            return
        } catch {
            
            print("Carrier info request error:", error)
            errorMessage = error.localizedDescription
        }
    }
}
