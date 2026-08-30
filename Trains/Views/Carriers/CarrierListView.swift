//
//  CarrierListView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct CarrierListView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @StateObject
    private var viewModel: CarrierListViewModel
    
    @State
    private var showFilters = false
    
    init(
        fromPoint: RoutePoint,
        toPoint: RoutePoint
    ) {
        _viewModel = StateObject(
            wrappedValue: CarrierListViewModel(
                fromPoint: fromPoint,
                toPoint: toPoint
            )
        )
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(viewModel.routeTitle)
                    .font(.system(size: 24, weight: .bold))
                
                if viewModel.filteredCarriers.isEmpty {
                    
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 220)
                    
                } else {
                    
                    LazyVStack(spacing: 8) {
                        
                        ForEach(
                            viewModel.filteredCarriers
                        ) { carrier in
                            
                            NavigationLink{
                                CarrierDetailsView(carrier: carrier)
                            } label: {
                                CarrierRow(carrier: carrier)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(AppColors.background)
        
        .navigationBarBackButtonHidden()
        
        .toolbar(.hidden, for: .tabBar)
        
        .toolbar {
            
            ToolbarItem(
                placement: .navigationBarLeading
            ) {
                
                Button {
                    dismiss()
                } label: {
                    
                    Image(systemName: "chevron.left")
                    .foregroundStyle(.primary)
                }
            }
        }
        
        .safeAreaInset(edge: .bottom) {
            
            Button {
                
                showFilters = true
                
            } label: {
                
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(AppColors.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background(AppColors.background)
        }
        
        .navigationDestination(isPresented: $showFilters){
            
            FiltersView(filter: $viewModel.filter)
        }
        
        .task {
            await viewModel.loadCarriers()
        }
    }
}
