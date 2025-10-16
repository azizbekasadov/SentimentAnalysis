//
//  ResponseStatsView.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import Charts
import SwiftUI

struct ResponseStatsView: View {
    let responses: [Response]
    
    var body: some View {
        GeometryReader { geometry in
            Chart(responses) { response in
                SectorMark(
                    angle: .value("Type", 1),
                    innerRadius: .ratio(0.75)
                )
                .foregroundStyle(by: .value("sentiment", response.sentiment))
            }
            .chartLegend(
                position: .trailing,
                alignment: .center
            )
            .frame(height: 200)
            .padding()
            .chartForegroundStyleScale([
                Sentiment.moderate: Sentiment.moderate.color,
                Sentiment.negative: Sentiment.negative.color,
                Sentiment.positive: Sentiment.positive.color
            ])
            .chartBackground { proxy in
                GeometryReader { geo in
                    if let anchor = proxy.plotFrame {
                        let frame = geo[anchor]
                        Image(systemName: "location")
                            .resizable()
                            .scaledToFit()
                            .frame(height: frame.height * 0.2)
                            .position(x: frame.midX, y: frame.midY)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}


#Preview {
    ResponseStatsView(responses: Response.sampleResponses.map {
        Response(
            id: NSUUID().uuidString,
            text: $0,
            score: Scorer().score($0)
        )
        }
        .sorted { $0.score < $1.score }
    )
}
