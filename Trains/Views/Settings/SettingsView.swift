//
//  SettingsView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct SettingsView: View {
    
    @StateObject
    private var viewModel = SettingsViewModel()
    
    @State
    private var showUserAgreement = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Темная тема")
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.isDarkMode)
                        .labelsHidden()
                }
                .frame(height: 56)
                
                Button {
                    showUserAgreement = true
                } label: {
                    HStack {
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .buttonStyle(.plain)
                .frame(height: 56)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text(viewModel.apiInformation)
                Text(viewModel.versionInformation)
            }
            .font(.system(size: 12))
            .padding(.bottom, 24)
        }
        .background(AppColors.background)
        .fullScreenCover(
            isPresented: $showUserAgreement
        ) {
            UserAgreementView()
        }
    }
}
