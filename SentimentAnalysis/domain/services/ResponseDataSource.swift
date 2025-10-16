//
//  ResponseDataSource.swift
//  SentimentAnalysis
//
//  Created by Azizbek Asadov on 16.10.2025.
//

import Foundation

protocol ResponseDataSource {
    func fetchResponses() async throws -> [Response]
}

enum ResponseDataSourceError: Error {
    case noResponses
}

final class MockResponseDataSource: ResponseDataSource {
    private let scorer: Scorer
    
    init(scorer: Scorer) {
        self.scorer = scorer
    }
    
    func fetchResponses() async throws -> [Response] {
        let responses: [Response] = Response.sampleResponses.map {
            Response(
                id: NSUUID().uuidString,
                text: $0,
                score: scorer.score($0)
            )
        }
        
        return responses
    }
}
