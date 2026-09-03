//
//  StationSelectionView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct StationSelectionView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel: StationSelectionViewModel

    @FocusState
    private var isSearchFocused: Bool

    let onSelect: (Station) -> Void

    init(
        city: City,
        onSelect: @escaping (Station) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: StationSelectionViewModel(
                city: city
            )
        )

        self.onSelect = onSelect
    }

    var body: some View {

        VStack(spacing: 0) {

            SearchField(
                text: $viewModel.searchText
            )
            .focused($isSearchFocused)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            if viewModel.filteredStations.isEmpty {

                Spacer()

                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))

                Spacer()

            } else {

                ScrollView {

                    LazyVStack(spacing: 0) {

                        ForEach(
                            viewModel.filteredStations
                        ) { station in

                            Button {

                                onSelect(station)

                            } label: {

                                SelectionRow(title: station.name)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .background(AppColors.background)
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()

        .toolbar {

            ToolbarItem(
                placement: .navigationBarLeading
            ) {

                Button {
                    dismiss()
                } label: {

                    Image(systemName: "chevron.left")
                    .foregroundStyle(.primary)
                }
            }
        }

        .onAppear {
            isSearchFocused = true
        }
    }
}
