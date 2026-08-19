//
//  CarrierRow.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct CarrierRow: View {

    let carrier: Carrier

    var body: some View {

        VStack(spacing: 16) {

            HStack(
                alignment: .top,
                spacing: 8
            ) {

                ZStack {

                    Color.white

                    if let logoURL = carrier.logoURL {

                        AsyncImage(url: logoURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }

                    } else {

                        Image(systemName: "tram.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .foregroundStyle(.black)
                    }
                }
                .frame(
                    width: 38,
                    height: 38
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                )
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 10
                        )
                    )

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text(carrier.name)
                        .font(
                            .system(size: 17)
                        )

                    if let transfer =
                        carrier.transferText {

                        Text(transfer)
                            .font(
                                .system(
                                    size: 12
                                )
                            )
                            .foregroundStyle(
                                Color.red
                            )
                    }
                }

                Spacer()

                Text(carrier.date)
                    .font(
                        .system(size: 12)
                    )
            }

            HStack(spacing: 8) {

                Text(
                    carrier.departureTime
                )

                line

                Text(carrier.duration)
                    .font(
                        .system(size: 12)
                    )

                line

                Text(
                    carrier.arrivalTime
                )
            }
            .font(.system(size: 17))
        }
        .padding(16)
        .background(
            AppColors.searchBackground
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    private var line: some View {

        Rectangle()
            .fill(
                Color.secondary
                    .opacity(0.4)
            )
            .frame(height: 1)
    }
}
