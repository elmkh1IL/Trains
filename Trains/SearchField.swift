//
//  SearchField.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct SearchField: View {

    @Binding var text: String

    var body: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Введите запрос",
                text: $text
            )
            .font(.system(size: 17))
            .foregroundStyle(.primary)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            if !text.isEmpty {

                Button {

                    text = ""

                } label: {

                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(
            AppColors.searchBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10
            )
        )
    }
}
