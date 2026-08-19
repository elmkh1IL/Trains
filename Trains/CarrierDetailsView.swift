//
//  CarrierDetailsView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct CarrierDetailsView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            Text("Карточка перевозчика")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView()
    }
}

