//
//  Story.swift
//  Trains
//
//  Created by el on 27.08.2026.
//
import Foundation

struct Story: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let description: String
    var isViewed: Bool
}
