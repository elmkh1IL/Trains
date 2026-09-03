//
//  CarrierDetailsView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct CarrierDetailsView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel: CarrierDetailsViewModel

    init(carrier: Carrier) {
        _viewModel = StateObject(wrappedValue: CarrierDetailsViewModel(carrier: carrier))
    }

    var body: some View {
        VStack(spacing: 0) {

            header

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                
                AsyncImage(url: viewModel.logoURL)
                { phase in
                    
                    switch phase {
                        
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                        
                    case .failure:
                        Image(systemName: "building.2")
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: 180, maxHeight: 70)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(.horizontal, 16)
            .padding(.top, 24)

            VStack(alignment: .leading, spacing: 32) {

                Text(viewModel.name)
                    .font(.system(size: 24, weight: .bold))

                VStack(alignment: .leading, spacing: 4) {
                    Text("E-mail")
                        .font(.system(size: 17))

                    Text(viewModel.email)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Телефон")
                        .font(.system(size: 17))

                    Text(viewModel.phone)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 24)

            Spacer()
        }
        .background(AppColors.background)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadCarrierInfo()
        }
    }

    private var header: some View {
        ZStack {
            Text("Информация о перевозчике")
                .font(.system(size: 17, weight: .bold))

            HStack {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 8)
    }
}
