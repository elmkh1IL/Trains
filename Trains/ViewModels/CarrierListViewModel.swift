//
//  CarrierListViewModel.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation
import Combine

@MainActor
final class CarrierListViewModel: ObservableObject {

    let fromPoint: RoutePoint
    let toPoint: RoutePoint

    @Published
    var filter = ScheduleFilter()

    @Published
    private(set) var allCarriers: [Carrier] = []

    @Published
    private(set) var isLoading = false

    @Published
    private(set) var screenState: ScreenState = .content

    private let service:
        CarrierScheduleServiceProtocol

    init(
        fromPoint: RoutePoint,
        toPoint: RoutePoint,
        service: CarrierScheduleServiceProtocol =
            CarrierScheduleService.shared
    ) {
        self.fromPoint = fromPoint
        self.toPoint = toPoint
        self.service = service
    }

    var routeTitle: String {
        "\(fromPoint.displayTitle) → \(toPoint.displayTitle)"
    }

    var filteredCarriers: [Carrier] {

        allCarriers.filter { carrier in

            let timeMatches =
                filter.periods.isEmpty ||
                filter.periods.contains { period in
                    period.contains(
                        hour: carrier.departureHour
                    )
                }

            let transferMatches: Bool

            switch filter.transfers {

            case .yes:
                transferMatches =
                    carrier.hasTransfer

            case .no:
                transferMatches =
                    !carrier.hasTransfer

            case nil:
                transferMatches = true
            }

            return timeMatches &&
                transferMatches
        }
    }

    func loadCarriers() async {

        guard !isLoading else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let carriers =
                try await service.getCarriers(
                    from: fromPoint.station.code,
                    to: toPoint.station.code
                )

            allCarriers = carriers
            screenState = .content

            print("Carriers loaded:", carriers.count)

        } catch {

            print("Carriers error:", error)

            let nsError = error as NSError

            if nsError.domain == NSURLErrorDomain,
               nsError.code ==
                NSURLErrorNotConnectedToInternet {

                screenState = .noInternet

            } else {

                screenState = .serverError
            }
        }
    }
}
