//
//  CitySelectionViewModel.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import Foundation
import Combine

@MainActor
final class CitySelectionViewModel: ObservableObject {

    @Published var searchText = ""

    @Published
    private(set) var cities: [City] = []

    @Published
    private(set) var screenState: ScreenState = .content

    @Published
    private(set) var isLoading = false

    private let service: StationsServiceProtocol

    init(
        service: any StationsServiceProtocol = StationsService.shared
    ) {
        self.service = service
    }

    var filteredCities: [City] {

        guard !searchText.isEmpty else {
            return cities
        }

        return cities.filter { city in
            city.name.localizedCaseInsensitiveContains(
                searchText
            )
        }
    }

    func loadCities() async {

        guard cities.isEmpty else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            
            let loadedCities = try await service.getCities()
            
            cities = loadedCities
            screenState = .content
            
        } catch is CancellationError {
            return
        } catch {
            
            print("loadCities error:", error)
            
            let nsError = error as NSError

            if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorNotConnectedToInternet {

                screenState = .noInternet

            } else {

                screenState = .serverError
            }
        }
    }
}
