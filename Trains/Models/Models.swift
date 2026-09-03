//
//  Models.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import Foundation

enum SelectionDirection: String, Identifiable, Sendable {
    case from
    case to

    var id: String {
        rawValue
    }
}

struct Station: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let code: String

    init(id: UUID = UUID(), name: String, code: String = "") {
        self.id = id
        self.name = name
        self.code = code
    }
}

struct RoutePoint: Hashable, Sendable {
    let cityName: String
    let station: Station

    var displayTitle: String {
        "\(cityName) (\(station.name))"
    }
}

struct City: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let stations: [Station]

    init(
        id: UUID = UUID(),
        name: String,
        stations: [Station]
    ) {
        self.id = id
        self.name = name
        self.stations = stations
    }
}

struct Carrier: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let logoURL: URL?
    let code: Int?
    let date: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let transferText: String?
    let hasTransfer: Bool
    let departureHour: Int

    init(
        id: UUID = UUID(),
        name: String,
        logoURL: URL? = nil,
        code: Int? = nil,
        date: String,
        departureTime: String,
        arrivalTime: String,
        duration: String,
        transferText: String? = nil,
        hasTransfer: Bool,
        departureHour: Int
    ) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.code = code
        self.date = date
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.transferText = transferText
        self.hasTransfer = hasTransfer
        self.departureHour = departureHour
    }
}

enum DeparturePeriod:
    String,
    CaseIterable,
    Identifiable,
    Hashable,
    Sendable {

    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"

    var id: String {
        rawValue
    }

    func contains(hour: Int) -> Bool {

        switch self {

        case .morning:
            return (6..<12).contains(hour)

        case .day:
            return (12..<18).contains(hour)

        case .evening:
            return (18..<24).contains(hour)

        case .night:
            return (0..<6).contains(hour)
        }
    }
}

enum TransferOption: String, Identifiable, Sendable {

    case yes = "Да"
    case no = "Нет"

    var id: String {
        rawValue
    }
}

struct ScheduleFilter: Equatable, Sendable {

    var periods:
        Set<DeparturePeriod> = []

    var transfers:
        TransferOption?
}

enum ScreenState: Sendable  {
    case content
    case noInternet
    case serverError
}
