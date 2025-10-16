//
//  SentimentSummaryView.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import SwiftUI

struct SentimentSummaryView: View {
    let responses: [Response]
    
    private var responsesBySentiment: [Sentiment: [Response]] {
        let groupedSentiments = Dictionary(
            grouping: responses,
            by: \.sentiment
        )
        return groupedSentiments
    }
    
    var body: some View {
        GroupBox {
            if let overallSentiment {
                HStack {
                    Label("Learning positive", systemImage: "hyphen")
                        .font(.headline)
                        .foregroundStyle(overallSentiment.color)
                    
                    Spacer()
                    
                    Text("\(responses.count) responses")
                }
                .padding(.bottom)
                
                HStack {
                    ForEach(Sentiment.allCases, id: \.rawValue) { sentiment in
                        SentimentPill(
                            sentiment: sentiment,
                            count: responsesBySentiment[sentiment]?.count ?? 0,
                            percentage: percentageBySentiment(sentiment)
                        )
                    }
                }
            } else {
                Text("No responses yet...")
            }
            
            Text("Max Sentiment: " + (overallSentiment?.rawValue ?? ""))
        } label: {
            Label("Sentiment Summary", systemImage: "chart.pie.fill")
        }
        .padding()
    }
    
    private var overallSentiment: Sentiment? {
        guard !responses.isEmpty else {
            return nil
        }
        
        let maxSentiment = responsesBySentiment.max { lhs, rhs in
            lhs.value.count < rhs.value.count
        }
        
        return maxSentiment?.key
    }
    
    private func percentageBySentiment(_ sentiment: Sentiment) -> Double {
        (Double(responsesBySentiment[sentiment]?.count ?? 0) / Double(responses.count)) * 100
    }
}

struct SentimentPill: View {
    let sentiment: Sentiment
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                Image(systemName: sentiment.icon)
                    .imageScale(.small)
                
                Text(sentiment.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Text("\(percentage.formatted(.number.precision(.fractionLength(0))))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(sentiment.color.opacity(0.12), in: Capsule())
        .foregroundStyle(sentiment.color)
    }
}

#Preview("SentimentPill") {
    SentimentPill(
        sentiment: .positive,
        count: 10,
        percentage: 2
    )
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
