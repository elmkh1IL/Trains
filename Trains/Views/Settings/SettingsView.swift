//
//  SettingsView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct SettingsView: View {

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            Text("Настройки")
                .font(.system(size: 24, weight: .bold))
        }
    }
}
