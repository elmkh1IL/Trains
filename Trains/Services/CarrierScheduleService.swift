//
//  CarrierScheduleService.swift
//  Trains
//
//  Created by el on 18.08.2026.
//
import Foundation
import OpenAPIURLSession

protocol CarrierScheduleServiceProtocol {
    func getCarriers(from: String, to: String) async throws -> [Carrier]
}

final class CarrierScheduleService: CarrierScheduleServiceProtocol {
    
    static let shared = CarrierScheduleService()
    
    private let scheduleService:
    ScheduleBetweenStationsServiceProtocol
    
    private init() {
        
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        
        scheduleService =
        ScheduleBetweenStationsService(
            client: client,
            apikey: APIConstants.apiKey
        )
    }
    
    init(
        scheduleService:
        ScheduleBetweenStationsServiceProtocol
    ) {
        self.scheduleService = scheduleService
    }
    
    func getCarriers(from: String, to: String) async throws -> [Carrier] {
        
        let requestDate = makeRequestDate()
        
        let result =
        try await scheduleService
            .getScheduleBetweenStations(
                fromStation: from,
                toStation: to,
                date: requestDate,
                transfers: true
            )
        
        let segments = result.segments ?? []
        
        var carriers: [Carrier] = []
        
        for segment in segments {
            
            guard
                let departure = segment.departure,
                let arrival = segment.arrival,
                let apiCarrier = segment.thread?.carrier
            else {
                continue
            }
            
            let carrier = Carrier(
                name: apiCarrier.title ?? "Перевозчик",
                logoURL: makeLogoURL(from: apiCarrier.logo),
                code: apiCarrier.code,
                date: formatDate(departure, fallbackDate: requestDate),
                departureTime: formatTime(departure),
                arrivalTime: formatTime(arrival),
                duration: formatDuration(segment.duration ?? 0),
                transferText: segment.has_transfers == true ? "С пересадкой" : nil,
                hasTransfer: segment.has_transfers ?? false,
                departureHour: getHour(from: departure)
            )
            
            carriers.append(carrier)
        }
        
        return carriers
    }
    
    private func makeRequestDate() -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale =
        Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat =
        "yyyy-MM-dd"
        
        return formatter.string(
            from: Date()
        )
    }
    
    private func makeLogoURL(from logo: String?) -> URL? {
        
        guard
            let logo,
            !logo.isEmpty
        else {
            return nil
        }
        
        if logo.hasPrefix("//") {
            
            return URL(
                string: "https:\(logo)"
            )
        }
        
        return URL(
            string: logo
        )
    }
    
    private func formatDate(_ departure: String, fallbackDate: String) -> String {
        
        let dateString: String
        
        if departure.contains("T") {
            
            let parts =
            departure.split(
                separator: "T"
            )
            
            guard let firstPart = parts.first
            else {
                return fallbackDate
            }
            
            dateString =
            String(firstPart)
            
        } else {
            
            dateString =
            fallbackDate
        }
        
        let inputFormatter =
        DateFormatter()
        
        inputFormatter.locale =
        Locale(
            identifier: "en_US_POSIX"
        )
        
        inputFormatter.dateFormat =
        "yyyy-MM-dd"
        
        guard
            let date =
                inputFormatter.date(
                    from: dateString
                )
        else {
            return dateString
        }
        
        let outputFormatter =
        DateFormatter()
        
        outputFormatter.locale =
        Locale(
            identifier: "ru_RU"
        )
        
        outputFormatter.dateFormat =
        "d MMMM"
        
        return outputFormatter.string(
            from: date
        )
    }
    
    private func formatTime(_ dateString: String) -> String {
        
        let timeString: String
        
        if dateString.contains("T") {
            
            let parts =
            dateString.split(
                separator: "T"
            )
            
            guard parts.count > 1
            else {
                return dateString
            }
            
            timeString =
            String(parts[1])
            
        } else {
            
            timeString =
            dateString
        }
        
        return String(
            timeString.prefix(5)
        )
    }
    
    private func getHour(from dateString: String) -> Int {
        
        let timeString: String
        
        if dateString.contains("T") {
            
            let parts =
            dateString.split(
                separator: "T"
            )
            
            guard parts.count > 1
            else {
                return 0
            }
            
            timeString =
            String(parts[1])
            
        } else {
            
            timeString =
            dateString
        }
        
        let hourString =
        timeString
            .split(separator: ":")
            .first
        
        guard let hourString
        else {
            return 0
        }
        
        return Int(hourString) ?? 0
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        
        let hours =
        seconds / 3600
        
        let minutes =
        seconds % 3600 / 60
        
        if minutes == 0 {
            return "\(hours) ч"
        }
        
        return "\(hours) ч \(minutes) мин"
    }
}
