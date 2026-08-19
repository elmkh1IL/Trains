//
//  SelectionRow.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct SelectionRow: View {

    let title: String

    var body: some View {

        HStack {

            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(.primary)

            Spacer()

            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.primary)
        }
        .frame(height: 60)
        .contentShape(Rectangle())
    }
}
