//
//  RootTabView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct RootTabView: View {
    
    init() {
            UITabBar.appearance().tintColor = .label
            UITabBar.appearance().unselectedItemTintColor = .systemGray3
        }

    var body: some View {

        TabView {

            NavigationStack {
                MainView()
            }
            .tabItem {
                Image(systemName: "arrow.up.message.fill")
            }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
    }
}
