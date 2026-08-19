//
//  StationsServiceProtocol.swift
//  Trains
//
//  Created by el on 17.08.2026.
//
import Foundation

protocol StationsServiceProtocol {
    func getCities() async throws -> [City]
}
