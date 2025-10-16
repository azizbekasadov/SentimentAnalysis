//
//  SentimentSummaryView.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import SwiftUI

struct SentimentSummaryView: View {
    let responses: [Response]
    
    var body: some View {
        GroupBox {
            Text("Sentiment Summary View")
                .padding()
            
            Text("Max Sentiment: " + (overallSentiment?.rawValue ?? ""))
        } label: {
            Label("Sentiment Summary", systemImage: "chart.pie.fill")
        }
    }
    
    private var overallSentiment: Sentiment? {
        guard !responses.isEmpty else {
            return nil
        }
        
        let groupedSentiments = Dictionary(
            grouping: responses) { response in
                response.sentiment
            }
        
        let maxSentiment = groupedSentiments.max { lhs, rhs in
            lhs.value.count < rhs.value.count
        }
        
        return maxSentiment?.key
    }
}

#Preview {
    SentimentSummaryView(
        responses: Response.sampleResponses.map {
            Response(
                id: NSUUID().uuidString,
                text: $0,
                score: Scorer().score($0)
            )
            }
            .sorted { $0.score < $1.score }
    )
}
