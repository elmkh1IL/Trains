//
//  UserAgreement.swift
//  Trains
//
//  Created by el on 28.08.2026.
//
import SwiftUI

struct UserAgreementView: View {
    
    @StateObject
    private var viewModel = UserAgreementViewModel()

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack {

            HStack {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                }

                Spacer()

                Text("viewModel.title")
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                Color.clear
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            ScrollView {
                Text(viewModel.agreementText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }
        }
        .foregroundStyle(.primary)
        .background(Color(.systemBackground))
    }
}
