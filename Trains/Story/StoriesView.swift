//
//  StoriesView.swift
//  Trains
//
//  Created by el on 30.08.2026.
//
import SwiftUI
import Combine

struct StoriesView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    let stories: [Story]
    let onStoryViewed: (Int) -> Void
    
    @State
    private var currentIndex: Int
    
    @State
    private var progress: CGFloat = 0
    
    private let secondsPerStory: TimeInterval = 10
    private let timerTickInterval: TimeInterval = 0.05

    @State
    private var timer = Timer.publish(
        every: 0.05,
        on: .main,
        in: .common
    )

    @State
    private var cancellable: Cancellable?
    
    init(
        stories: [Story],
        startIndex: Int,
        onStoryViewed: @escaping (Int) -> Void
    ) {
        self.stories = stories
        self.onStoryViewed = onStoryViewed
        _currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        ZStack {
            
            AppColors.background
                .ignoresSafeArea()
            
            if stories.indices.contains(currentIndex) {
                
                storyContent(stories[currentIndex])
                    .overlay {
                        tapAreas
                    }
                    .overlay(alignment: .top) {
                        progressIndicators
                    }
                    .overlay(alignment: .topTrailing) {
                        closeButton
                    }
                    .simultaneousGesture(swipeGesture)
            }
        }
        .onAppear {
            onStoryViewed(currentIndex)
            timer = Self.createTimer(interval: timerTickInterval)
            cancellable = timer.connect()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
        .onChange(of: currentIndex) { _, newIndex in
            progress = 0
            onStoryViewed(newIndex)
            resetTimer()
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }
    
    private func storyContent(_ story: Story) -> some View {
        
        ZStack(alignment: .bottomLeading) {
            
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(story.title)
                    .font(.system(size: 34, weight: .bold))
                    .lineLimit(2)
                
                Text(story.description)
                    .font(.system(size: 20))
                    .lineLimit(3)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 52)
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
        
    }
    
    private var tapAreas: some View {
        HStack(spacing: 0) {
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    showPreviousStory()
                }
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    showNextStory()
                }
        }
    }
    
    private var progressIndicators: some View {
        StoryProgressView(
            storiesCount: stories.count,
            currentIndex: currentIndex,
            progress: progress
        )
        .padding(.horizontal, 12)
        .padding(.top, 20)
    }
    
    private var swipeGesture: some Gesture {

        DragGesture(minimumDistance: 20)
            .onEnded { value in

                let horizontalOffset = value.translation.width

                let verticalOffset = value.translation.height

                let horizontalDistance = abs(horizontalOffset)

                let verticalDistance = abs(verticalOffset)

                if verticalDistance > horizontalDistance {

                    if verticalOffset > 80 {
                        dismiss()
                    }

                    return
                }

                if horizontalDistance > 80 {

                    if horizontalOffset < 0 {
                        showNextStory()
                    } else {
                        showPreviousStory()
                    }
                }
            }
    }
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image("Close")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .padding(.top, 56)
        .padding(.trailing, 12)
    }
    
    private func showNextStory() {
        let nextIndex = currentIndex + 1
        
        if stories.indices.contains(nextIndex) {
            currentIndex = nextIndex
        } else {
            dismiss()
        }
    }
    
    private func resetTimer() {
        cancellable?.cancel()

        timer = Self.createTimer(
            interval: timerTickInterval
        )

        cancellable = timer.connect()
    }
    
    private static func createTimer(interval: TimeInterval) -> Timer.TimerPublisher {

        Timer.publish(
            every: interval,
            on: .main,
            in: .common
        )
    }
    
    private func timerTick() {
        let progressPerTick = CGFloat(timerTickInterval / secondsPerStory)

        progress += progressPerTick

        if progress >= 1 {
            progress = 1
            showNextStory()
        }
    }
    
    private func showPreviousStory() {
        let previousIndex = currentIndex - 1
        
        if stories.indices.contains(previousIndex) {
            currentIndex = previousIndex
        }
    }
}



