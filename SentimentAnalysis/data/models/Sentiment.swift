//
//  Sentiment.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import Charts
import SwiftUI
import Foundation

// TODO: redo it with strategy and add unit tests;
enum Sentiment: String, Plottable, CaseIterable  {
    case positive = "Positive"
    case moderate = "Moderate"
    case negative = "Negative"
    
    
    init(score: Double) {
        if score > 0.2 {
            self = .positive
        } else if score < -0.2 {
            self = .negative
        } else {
            self = .moderate
        }
    }
    
    var icon: String {
        switch self {
        case .positive:
            return "chevron.up.2"
        case .moderate:
            return "minus"
        case .negative:
            return "chevron.down.2"
        }
    }
    
    var color: Color {
        switch self {
        case .positive:
            return .green
        case .moderate:
            return .gray
        case .negative:
            return .red
        }
    }
}
