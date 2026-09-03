//
//  SettingsViewModel.swift
//  Trains
//
//  Created by el on 03.09.2026.
//
import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published
    var isDarkMode: Bool {
        didSet {
            userDefaults.set(isDarkMode, forKey: Self.darkModeKey)
        }
    }
    
    let apiInformation = "Приложение использует API «Яндекс.Расписания»"
    
    let versionInformation = "Версия 1.0 (beta)"
    
    private let userDefaults: UserDefaults
    
    private static let darkModeKey = "isDarkMode"
    
    init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
        self.isDarkMode = userDefaults.bool(forKey: Self.darkModeKey)
    }
}

