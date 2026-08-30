//
//  ErrorStateView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct ErrorStateView: View {

    let state: ScreenState

    var body: some View {

        VStack(spacing: 16) {

            Spacer()

            switch state {

            case .noInternet:

                Image("NoInternet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 223, height: 223)

                Text("Нет интернета")
                    .font(.system(size: 24, weight: .bold))

            case .serverError:

                Image("ServerError")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 223, height: 223)

                Text("Ошибка сервера")
                    .font(.system(size: 24, weight: .bold))

            case .content:

                EmptyView()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}
