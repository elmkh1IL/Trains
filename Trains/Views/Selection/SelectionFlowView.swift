//
//  SelectionFlowView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct SelectionFlowView: View {

    let direction: SelectionDirection

    let onStationSelected:
        (City, Station) -> Void

    var body: some View {

        NavigationStack {

            CitySelectionView(
                onStationSelected: onStationSelected
            )
        }
    }
}
