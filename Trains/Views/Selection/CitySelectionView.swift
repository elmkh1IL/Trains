//
//  CitySelectionView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct CitySelectionView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel = CitySelectionViewModel()

    let onStationSelected: (City, Station) -> Void

    var body: some View {

        VStack(spacing: 0) {

            SearchField(
                text: $viewModel.searchText
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            if viewModel.isLoading {

                Spacer()

                ProgressView()

                Spacer()

            } else if viewModel.screenState == .noInternet {

                ErrorStateView(
                    state: .noInternet
                )

            } else if viewModel.screenState == .serverError {

                ErrorStateView(
                    state: .serverError
                )

            } else if viewModel.filteredCities.isEmpty {

                Spacer()

                Text("Город не найден")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )

                Spacer()

            } else {

                ScrollView {

                    LazyVStack(spacing: 0) {

                        ForEach(
                            viewModel.filteredCities
                        ) { city in

                            NavigationLink(
                                value: city
                            ) {

                                SelectionRow(
                                    title: city.name
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .background(AppColors.background)
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(
                placement: .navigationBarLeading
            ) {

                Button {
                    dismiss()
                } label: {

                    Image(
                        systemName: "chevron.left"
                    )
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.primary)
                }
            }
        }
        .navigationDestination(
            for: City.self
        ) { city in

            StationSelectionView(
                city: city
            ) { station in

                onStationSelected(
                    city,
                    station
                )
            }
        }
        .task {
            await viewModel.loadCities()
        }
    }
}
