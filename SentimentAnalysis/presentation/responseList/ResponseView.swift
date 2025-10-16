//
//  ResponseView.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import SwiftUI

struct ResponseView: View {
    let response: Response
    
    var body: some View {
        HStack {
            Text(response.text)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: response.sentiment.icon)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(response.sentiment.color)
                }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: UIColor.systemBackground))
        }
    }
}

#Preview {
    ResponseView(
        response: Response(
            id: NSUUID().uuidString,
            text: Response.sampleResponses[0],
            score: 0.8
        )
    )
}
