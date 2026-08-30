//
//  StoriesCollectionView.swift
//  Trains
//
//  Created by el on 30.08.2026.
//
import SwiftUI

struct StoriesCollectionView: View {
    
    let stories: [Story]
    let onStoryTap: (Int) -> Void
    
    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack(spacing: 12) {
                
                ForEach(Array(stories.enumerated()),
                        id: \.element.id)
                { index, story in
                    
                    Button {
                        onStoryTap(index)
                    } label: {
                        StoryCardView(story: story)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(height: 140)
    }
}
