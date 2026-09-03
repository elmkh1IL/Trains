//
//  StoryProgressView.swift
//  Trains
//
//  Created by el on 30.08.2026.
//
import SwiftUI

struct StoryProgressView: View {

    let storiesCount: Int
    let currentIndex: Int
    let progress: CGFloat

    var body: some View {
        HStack(spacing: 6) {

            ForEach(0..<storiesCount, id: \.self) { index in

                GeometryReader { geometry in

                    ZStack(alignment: .leading) {

                        Capsule()
                            .fill(Color.white)

                        Capsule()
                            .fill(AppColors.blue)
                            .frame(width: fillWidth(for: index,totalWidth: geometry.size.width))
                    }
                }
                .frame(height: 6)
            }
        }
        .frame(height: 6)
    }

    private func fillWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {

        if index < currentIndex {
            return totalWidth
        }

        if index == currentIndex {
            return totalWidth * progress
        }

        return 0
    }
}
