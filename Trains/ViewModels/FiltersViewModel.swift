//
//  FiltersViewModel.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation
import Combine

@MainActor
final class FiltersViewModel: ObservableObject {

    @Published private(set) var draft: ScheduleFilter

    init(filter: ScheduleFilter) {
        self.draft = filter
    }

    var shouldShowApply: Bool {
        !draft.periods.isEmpty ||
        draft.transfers != nil
    }

    func togglePeriod(_ period: DeparturePeriod) {
        if draft.periods.contains(period) {
            draft.periods.remove(period)
        } else {
            draft.periods.insert(period)
        }
    }

    func selectTransferOption(_ option: TransferOption) {
        draft.transfers = option
    }

    func isPeriodSelected(_ period: DeparturePeriod) -> Bool {
        draft.periods.contains(period)
    }

    func isTransferOptionSelected(_ option: TransferOption) -> Bool {
        draft.transfers == option
    }
}
