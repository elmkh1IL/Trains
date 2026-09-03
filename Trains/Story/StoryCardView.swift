//
//  StoryCardView.swift
//  Trains
//
//  Created by el on 30.08.2026.
//
import SwiftUI

struct StoryCardView: View {
    
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 140)
                .opacity(story.isViewed ? 0.5 : 1)
                .clipped()
            
            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white)
                .lineLimit(3)
                .padding(8)
        }
        .frame(width: 92, height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            if !story.isViewed {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(AppColors.blue, lineWidth: 4)
            }
        }
    }
}
