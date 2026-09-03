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
    private let service: CarrierInfoServiceProtocol
    
    init(
        carrier: Carrier,
        service: CarrierInfoServiceProtocol
    ) {
        self.carrier = carrier
        self.service = service
    }
    
    var name: String {
        carrierInfo?.carrier?.title
        ?? carrier.name
    }
    
    var email: String {
        guard let email = carrierInfo?.carrier?.email,
              !email.isEmpty else {
            return isLoading ? "Загрузка..." : "Нет данных"
        }
        
        return email
    }
    
    var phone: String {
        guard let phone = carrierInfo?.carrier?.phone,
              !phone.isEmpty else {
            return isLoading ? "Загрузка..." : "Нет данных"
        }
        
        return phone
    }
    
    var logoURL: URL? {
        guard let logo = carrierInfo?.carrier?.logo,
              !logo.isEmpty else {
            return carrier.logoURL
        }
        
        if logo.hasPrefix("//") {
            return URL(string: "https:" + logo)
        }
        
        return URL(string: logo)
    }
    
    func loadCarrierInfo() async {
        
        guard let code = carrier.code else {
            
            errorMessage = "Не найден код перевозчика"
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            carrierInfo = try await service.getCarrierInfo(
                code: String(code))
            
        } catch {
            print("Carrier info request error:", error)
            errorMessage = error.localizedDescription
        }
    }
}
