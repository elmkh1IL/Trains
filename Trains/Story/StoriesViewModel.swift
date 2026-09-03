//
//  StoriesViewModel.swift
//  Trains
//
//  Created by el on 30.08.2026.
//
import Foundation
import Combine

@MainActor
final class StoriesViewModel: ObservableObject {

    @Published
    private(set) var stories: [Story] = [
        Story(
            id: 0,
            imageName: "story1",
            title: "Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            isViewed: true
        ),

        Story(
            id: 1,
            imageName: "story2",
            title: "Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            isViewed: false
        ),

        Story(
            id: 2,
            imageName: "story3",
            title: "Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            isViewed: false
        ),

        Story(
            id: 3,
            imageName: "story4",
            title: "Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            isViewed: false
        )
    ]

    func markAsViewed(at index: Int) {
        guard stories.indices.contains(index) else {
            return
        }

        stories[index].isViewed = true
    }
}
