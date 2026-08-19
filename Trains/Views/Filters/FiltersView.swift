//
//  FiltersView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct FiltersView: View {

    @Environment(\.dismiss)
    private var dismiss

    
    @Binding
    private var filter: ScheduleFilter

    @StateObject
    private var viewModel: FiltersViewModel

    init(
        filter: Binding<ScheduleFilter>
    ) {
        self._filter = filter

        self._viewModel = StateObject(
            wrappedValue: FiltersViewModel(
                filter: filter.wrappedValue
            )
        )
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            Text("Время отправления")
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .padding(.top, 24)
                .padding(.bottom, 16)

            ForEach(
                DeparturePeriod.allCases
            ) { period in

                Button {

                    viewModel.togglePeriod(period)

                } label: {

                    HStack {

                        Text(period.rawValue)

                        Spacer()

                        Image(
                            systemName:
                                viewModel.isPeriodSelected(period)
                                ? "checkmark.square.fill"
                                : "square"
                        )
                        .font(.system(size: 24))
                    }
                    .foregroundStyle(.primary)
                    .frame(height: 60)
                }
                .buttonStyle(.plain)
            }

            Text(
                "Показывать варианты с пересадками"
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .padding(.top, 16)
            .padding(.bottom, 12)

            transferRow(.yes)

            transferRow(.no)

            Spacer()
        }
        .padding(.horizontal, 16)
        .background(AppColors.background)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)

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
                    .foregroundStyle(.primary)
                }
            }
        }

        .safeAreaInset(edge: .bottom) {

            if viewModel.shouldShowApply {

                Button {

                    filter = viewModel.draft

                    dismiss()

                } label: {

                    Text("Применить")
                        .font(
                            .system(
                                size: 17,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(AppColors.blue)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .background(AppColors.background)
            }
        }
    }

    private func transferRow(
        _ option: TransferOption
    ) -> some View {

        Button {

            viewModel.selectTransferOption(
                option
            )

        } label: {

            HStack {

                Text(option.rawValue)

                Spacer()

                Image(
                    systemName:
                        viewModel
                            .isTransferOptionSelected(option)
                        ? "largecircle.fill.circle"
                        : "circle"
                )
                .font(.system(size: 24))
            }
            .foregroundStyle(.primary)
            .frame(height: 60)
        }
        .buttonStyle(.plain)
    }
}
