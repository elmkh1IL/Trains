//
//  MainView.swift
//  Trains
//
//  Created by el on 16.08.2026.
//
import SwiftUI

struct MainView: View {
    
    @StateObject
    private var viewModel = MainViewModel()
    
    @State
    private var selectionDirection: SelectionDirection?
    
    @State
    private var showCarriers = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
                .frame(height: 32)
            
            routeView
            
            if viewModel.canSearch {
                searchButton
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(AppColors.background)
        .navigationBarHidden(true)
        
        .fullScreenCover(
            item: $selectionDirection
        ) { direction in
            
            SelectionFlowView(
                direction: direction
            ) { city, station in
                
                viewModel.selectStation(
                    city: city,
                    station: station,
                    direction: direction
                )
                
                selectionDirection = nil
            }
        }
        
        .navigationDestination(
            isPresented: $showCarriers
        ) {
            
            if let fromPoint = viewModel.fromPoint,
               let toPoint = viewModel.toPoint {
                
                CarrierListView(
                    fromPoint: fromPoint,
                    toPoint: toPoint
                )
            }
        }
    }
        
        private var routeView: some View {
            
            HStack(spacing: 16) {
                
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    
                    routeButton(
                        text: viewModel.fromStation,
                        placeholder: "Откуда"
                    ) {
                        selectionDirection = .from
                    }
                    
                    routeButton(
                        text: viewModel.toStation,
                        placeholder: "Куда"
                    ) {
                        selectionDirection = .to
                    }
                }
                .background(AppColors.background)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                )
                
                Button {
                    
                    viewModel.swapStations()
                    
                } label: {
                    
                    Image(
                        systemName: "arrow.up.arrow.down"
                    )
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(AppColors.blue)
                    .frame(
                        width: 44,
                        height: 44
                    )
                    .background(AppColors.background)
                    .clipShape(Circle())
                }
            }
            .padding(16)
            .background(AppColors.blue)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )
        }
        
        private func routeButton(
            text: String,
            placeholder: String,
            action: @escaping () -> Void
        ) -> some View {
            
            Button(action: action) {
                
                HStack {
                    
                    Text(
                        text.isEmpty
                        ? placeholder
                        : text
                    )
                    .font(.system(size: 17))
                    .foregroundStyle(
                        text.isEmpty
                        ? Color.secondary
                        : Color.primary
                    )
                    .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        
        private var searchButton: some View {
            
            Button {
                
                showCarriers = true
                
            } label: {
                
                Text("Найти")
                    .font(
                        .system(
                            size: 17,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        width: 150,
                        height: 60
                    )
                    .background(AppColors.blue)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                    )
            }
        }
    }
